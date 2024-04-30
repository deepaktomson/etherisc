import json
import os

from web3 import Web3

from brownie.convert import to_bytes
from brownie.network import accounts
from brownie.network.account import Account
from brownie.project import GifContractsProject

from brownie import (
    Wei,
    Contract, 
    network,
    interface
)

from scripts.const import (
    GIF_RELEASE,
)

from scripts.util import (
    encode_function_data,
    get_account,
    get_package,
    s2h,
    s2b,
    contract_from_address,
)

class GifRegistry(object):

    def __init__(
        self, 
        instanceOperator: Account, 
        registryAddress: Account,
        publish_source=False
    ):
        # gif = get_package('gif-contracts')
        gif = GifContractsProject

        if instanceOperator is not None and registryAddress is None:
            controller = gif.RegistryController.deploy(
                {'from': instanceOperator},
                publish_source=publish_source)

            encoded_initializer = encode_function_data(
                s2b(GIF_RELEASE),
                initializer=controller.initializeRegistry)

            proxy = gif.CoreProxy.deploy(
                controller.address,
                encoded_initializer, 
                {'from': instanceOperator},
                publish_source=publish_source)

            registry = contract_from_address(gif.RegistryController, proxy.address)
            registry.register(s2b('Registry'), proxy.address, {'from': instanceOperator})
            registry.register(s2b('RegistryController'), controller.address, {'from': instanceOperator})

            registryAddress = proxy.address

        elif registryAddress is not None:
            registry = contract_from_address(gif.RegistryController, registryAddress)
            instanceOperatorServiceAddress = registry.getContract(s2b('InstanceOperatorService'))
            instanceOperatorService = contract_from_address(gif.InstanceOperatorService, instanceOperatorServiceAddress)
            
            instanceOperator = instanceOperatorService.owner()

        else:
            print('ERROR invalid arguments for GifRegistry: registryAddress and instanceOperator must not both be None')
            return

        self.gif = gif
        self.instanceOperator = instanceOperator
        self.registry = contract_from_address(interface.IRegistry, registryAddress)

        print('owner {}'.format(instanceOperator))
        print('registry.address {}'.format(self.registry.address))
        print('registry.getContract(\'InstanceOperatorService\') {}'.format(self.registry.getContract(s2b('InstanceOperatorService'))))

    def getOwner(self) -> Account:
        return self.instanceOperator

    def getRegistry(self) -> interface.IRegistry:
        return self.registry


class GifInstance(GifRegistry):

    def __init__(
        self, 
        instanceOperator:Account=None, 
        instanceWallet:Account=None, 
        registryAddress:Account=None,
        publish_source=False
    ):
        super().__init__(
            instanceOperator,
            registryAddress,
            publish_source
        )
        
        if registryAddress is None:
            self.deployWithRegistry(publish_source)

            self.instanceOperatorService.setInstanceWallet(
                instanceWallet,
                {'from': instanceOperator})

        else:
            self.createFromRegistry()


    def createFromRegistry(self):
        gif = self.gif
        registry = self.getRegistry()
        instanceOperator = self.getOwner()

        # minimal set of contracts
        self.instanceService = contract_from_address(
            gif.InstanceService,
            registry.getContract(s2b('InstanceService')))
        
        self.componentOwnerService = contract_from_address(
            gif.ComponentOwnerService,
            registry.getContract(s2b('ComponentOwnerService')))

        self.instanceOperatorService = contract_from_address(
            gif.InstanceOperatorService,
            registry.getContract(s2b('InstanceOperatorService')))
        
        # other contracts needed
        self.treasury = contract_from_address(
            gif.TreasuryModule,
            registry.getContract(s2b('Treasury')))


    def deployWithRegistry(self, publish_source=False):
        gif = self.gif
        registry = self.getRegistry()
        instanceOperator = self.getOwner()

        self.bundleToken = deployGifToken("BundleToken", gif.BundleToken, registry, instanceOperator, publish_source)
        self.riskpoolToken = deployGifToken("RiskpoolToken", gif.RiskpoolToken, registry, instanceOperator, publish_source)

        # modules (need to be deployed first)
        # deploy order needs to respect module dependencies
        self.access = deployGifModuleV2("Access", gif.AccessController, registry, instanceOperator, gif, publish_source)
        self.component = deployGifModuleV2("Component", gif.ComponentController, registry, instanceOperator, gif, publish_source)
        self.query = deployGifModuleV2("Query", gif.QueryModule, registry, instanceOperator, gif, publish_source)
        self.license = deployGifModuleV2("License", gif.LicenseController, registry, instanceOperator, gif, publish_source)
        self.policy = deployGifModuleV2("Policy", gif.PolicyController, registry, instanceOperator, gif, publish_source)
        self.bundle = deployGifModuleV2("Bundle", gif.BundleController, registry, instanceOperator, gif, publish_source)
        self.pool = deployGifModuleV2("Pool", gif.PoolController, registry, instanceOperator, gif, publish_source)
        self.treasury = deployGifModuleV2("Treasury", gif.TreasuryModule, registry, instanceOperator, gif, publish_source)

        # TODO these contracts do not work with proxy pattern
        self.policyFlow = deployGifService(gif.PolicyDefaultFlow, registry, instanceOperator, publish_source)

        # services
        self.instanceService = deployGifModuleV2("InstanceService", gif.InstanceService, registry, instanceOperator, gif, publish_source)
        self.componentOwnerService = deployGifModuleV2("ComponentOwnerService", gif.ComponentOwnerService, registry, instanceOperator, gif, publish_source)
        self.oracleService = deployGifModuleV2("OracleService", gif.OracleService, registry, instanceOperator, gif, publish_source)
        self.riskpoolService = deployGifModuleV2("RiskpoolService", gif.RiskpoolService, registry, instanceOperator, gif, publish_source)

        # TODO these contracts do not work with proxy pattern
        self.productService = deployGifService(gif.ProductService, registry, instanceOperator, publish_source)

        # needs to be the last module to register as it will 
        # perform some post deploy wirings and changes the address 
        # of the instance operator service to its true address
        self.instanceOperatorService = deployGifModuleV2("InstanceOperatorService", gif.InstanceOperatorService, registry, instanceOperator, gif, publish_source)

        # post deploy wiring steps
        # self.bundleToken.setBundleModule(self.bundle)

        # ensure that the instance has 32 contracts when freshly deployed
        assert 32 == registry.contracts()

    def getTreasury(self) -> interface.ITreasury:
        return self.treasury

    def getInstanceOperatorService(self) -> interface.IInstanceOperatorService:
        return self.instanceOperatorService

    def getInstanceService(self) -> interface.IInstanceService:
        return self.instanceService
    
    def getRiskpoolService(self) -> interface.IRiskpoolService:
        return self.riskpoolService
    
    def getProductService(self) -> interface.IProductService:
        return self.productService
    
    def getComponentOwnerService(self) -> interface.IComponentOwnerService:
        return self.componentOwnerService
    
    def getOracleService(self) -> interface.IOracleService:
        return self.oracleService


# generic upgradable gif module deployment
def deployGifModule(
    controllerClass, 
    storageClass, 
    registry, 
    owner,
    publish_source=False
):
    controller = controllerClass.deploy(
        registry.address, 
        {'from': owner},
        publish_source=publish_source)
    
    storage = storageClass.deploy(
        registry.address, 
        {'from': owner},
        publish_source=publish_source)

    controller.assignStorage(storage.address, {'from': owner})
    storage.assignController(controller.address, {'from': owner})

    registry.register(controller.NAME.call(), controller.address, {'from': owner})
    registry.register(storage.NAME.call(), storage.address, {'from': owner})

    return contract_from_address(controllerClass, storage.address)


# gif token deployment
def deployGifToken(
    tokenName,
    tokenClass,
    registry,
    owner,
    publish_source=False
):
    print('token {} deploy'.format(tokenName))
    token = tokenClass.deploy(
        {'from': owner},
        publish_source=publish_source)

    tokenNameB32 = s2b(tokenName)
    print('token {} register'.format(tokenName))
    registry.register(tokenNameB32, token.address, {'from': owner})

    return token


# generic open zeppelin upgradable gif module deployment
def deployGifModuleV2(
    moduleName,
    controllerClass,
    registry, 
    owner,
    gif,
    publish_source=False
):
    print('module {} deploy controller'.format(moduleName))
    controller = controllerClass.deploy(
        {'from': owner},
        publish_source=publish_source)

    encoded_initializer = encode_function_data(
        registry.address,
        initializer=controller.initialize)

    print('module {} deploy proxy'.format(moduleName))
    proxy = gif.CoreProxy.deploy(
        controller.address, 
        encoded_initializer, 
        {'from': owner},
        publish_source=publish_source)

    moduleNameB32 = s2b(moduleName)
    controllerNameB32 = s2b('{}Controller'.format(moduleName)[:32])

    print('module {} ({}) register controller'.format(moduleName, controllerNameB32))
    registry.register(controllerNameB32, controller.address, {'from': owner})
    print('module {} ({}) register proxy'.format(moduleName, moduleNameB32))
    registry.register(moduleNameB32, proxy.address, {'from': owner})

    return contract_from_address(controllerClass, proxy.address)


# generic upgradable gif service deployment
def deployGifService(
    serviceClass, 
    registry, 
    owner,
    publish_source=False
):
    service = serviceClass.deploy(
        registry.address, 
        {'from': owner},
        publish_source=publish_source)

    registry.register(service.NAME.call(), service.address, {'from': owner})

    return service
