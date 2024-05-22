brownie compile --all
brownie console

================================================================
DEPLOYING GIF
================================================================
>>> from scripts.instance import GifInstance
>>> instance = GifInstance(accounts[0], accounts[1])
>>> f = open("./gif_instance_address.txt", "w")
>>> f.writelines("registry=%s\n" % (instance.getRegistry().address))
>>> f.close()

================================================================
DEPLOYING PRODUCT
================================================================

>>> from scripts.deploy_fire import all_in_1, verify_deploy, create_bundle, create_policy, help
>>> (customer, customer2, product, oracle, riskpool, riskpoolWallet, investor, usdc, instance, instanceService, instanceOperator, bundleId, processId, d) = all_in_1(deploy_all=False)
>>> verify_deploy(d, usdc, product)
>>> f = open("./gif_instance_address.txt", "a")
>>> f.writelines("product=%s\n" % (product.address))
>>> f.writelines("productId=%s\n" % (product.getId()))
>>> f.writelines("riskpool=%s\n" % (riskpool.address))
>>> f.writelines("riskpoolId=%s\n" % (riskpool.getId()))
>>> f.writelines("oracle=%s\n" % (oracle.address))
>>> f.writelines("oracleId=%s\n" % (oracle.getId()))
>>> f.writelines("usdc=%s\n" % (usdc.address))
>>> f.writelines("customer=%s\n" % (customer.address))
>>> f.writelines("instanceService=%s\n" % (instanceService.address))
>>> f.close()

from scripts.deploy_custom import all_in_1, verify_deploy, create_bundle, create_policy, help
(customer, customer2, product, oracle, riskpool, riskpoolWallet, investor, usdc, instance, instanceService, instanceOperator, bundleId, processId, d) = all_in_1(deploy_all=False)

from scripts.deploy_nebula import all_in_1, verify_deploy, create_bundle, create_policy, help

FireProduct[0].applyForPolicy("dpk@abc.com", 30, 1, "0x7CD8790f691E0D2349352303DB4BE9829B379Cec", "LIFE", 10 ** 18, { from: accounts[3] })

create_bundle(instance, instanceOperator, riskpool, investor)
processId = create_policy(instance, instanceOperator, product, customer2, "deep@xyz.com", 25, 1, accounts[-1].address)


brownie compile --all
brownie console
deploy gif
copy registry address to gif_instance_address.txt
deploy product
copy address to dapp
copy abi to dapp
accounts.add()
accounts[10].transfer(accounts[-1], "10 ether")
connect accounts[-1] to dapp
accounts.add() for nominee
add this account to wallet
accounts[-1].private_key to get private key

import Usdc token to policy holder account
transfer test Usdc to policy h older for testing

Usdc[0].transfer(accounts[-2], 10 ** 8, { "from": instanceOperator })
Usdc[0].approve(instanceService.getTreasuryAddress(), 10 ** 9, { "from": accounts[-2] })

policy = NebulaProduct[0].applyForPolicy("dpk1@abc.com", 20, 1, "0xE06F7115A40acfA576C0A66eF48B8F9519e99262", "LIFE", 10 ** 18, { "from": accounts[-2]  })

processId = policy.events['LogApplicationCreated'][0]['processId']

NebulaProduct[0].acceptApplication(processId, {"from": instanceOperator })

state is still 0 ? not underwritten why ?

============================================================
1. Creating a new policy
============================================================
brownie console

from scripts.util import s2h


usdc.transfer(customer, 100000 * 10 ** 6, {'from': instanceOperator})
usdc.approve(instanceService.getTreasuryAddress(), 100000 * 10 ** 6, {'from': customer})


policy = product.applyForPolicy('My house', 10000 * 10 ** 6, {'from': customer})


processId = policy.events['LogApplicationCreated'][0]['processId']


instanceService.getApplication(processId).dict()




==================== END ==========================================


=================================================================
2. Sending an oracle response to trigger a claim creation and payout
=================================================================


requestId = oracle.requestId('My house')
oracle_tx = oracle.respond(requestId, s2h('M'))

oracle_tx.events

==================== END ==========================================

==================================================================
3. Expiring a policy
==================================================================


product.expirePolicy(processId)

==================== END ==========================================

GIF - 65 contracts
approx : 4.5 to 5 crore gas
gas limit: 1.2 crore
gas price: 1e-09
web3.eth.gas_price : 2 * (10 ** 10)

GIF - 1 eth
Main net: gas price - 8.5 gwei ~ 0.5 eth
Sepolia - 3 eth

Arbitrum - 0.06 gwei gas price


Product: apprx - 1 crore
https://docs.etherisc.com/sandbox/fire_insurance_interaction


PolicyDefaultFlow.sol, Rispool.sol. PoolController.sol