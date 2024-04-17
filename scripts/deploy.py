from brownie import TestCoin
from scripts.deploy_ayii import (
    stakeholders_accounts_ganache,
    check_funds,
    amend_funds,
    deploy,
    deploy_setup_including_token,
    from_registry,
    from_component,
)

from scripts.instance import (
  GifInstance, 
  dump_sources
)

from scripts.util import (
  s2b, 
  b2s, 
  contract_from_address,
)

def main():
    # for ganche the command below may be used
    # for other chains, use accounts.add() and record the mnemonics
    a = stakeholders_accounts_ganache()

    # deploy TestCoin with instanceOperator 
    usdc = TestCoin.deploy({'from': a['instanceOperator']})

    # check_funds checks which stakeholder accounts need funding for the deploy
    # also, it checks if the instanceOperator has a balance that allows to provided
    # the missing funds for the other accounts
    check_funds(a)

    # amend_funds transfers missing funds to stakeholder addresses using the
    # avaulable balance of the instanceOperator
    amend_funds(a)

    d = deploy_setup_including_token(a, usdc)

    (
    componentOwnerService,customer1,customer2,erc20Token,instance,instanceOperator,instanceOperatorService,instanceService,
    instanceWallet,insurer,investor,oracle,oracleProvider,processId1,processId2,product,productOwner,riskId1,riskId2,
    riskpool,riskpoolKeeper,riskpoolWallet
    )=(
    d['componentOwnerService'],d['customer1'],d['customer2'],d['erc20Token'],d['instance'],d['instanceOperator'],d['instanceOperatorService'],d['instanceService'],
    d['instanceWallet'],d['insurer'],d['investor'],d['oracle'],d['oracleProvider'],d['processId1'],d['processId2'],d['product'],d['productOwner'],d['riskId1'],d['riskId2'],
    d['riskpool'],d['riskpoolKeeper'],d['riskpoolWallet']
    )

    # the deployed setup can now be used
    # example usage
    # instanceOperator
    instance.getRegistry()

    instanceService.getChainName()
    instanceService.getInstanceId()

    product.getId()
    b2s(product.getName())

    # customer1
    instanceService.getMetadata(processId1)
    instanceService.getApplication(processId1)
    instanceService.getPolicy(processId1)

    tx = product.triggerOracle(processId1, {'from': insurer})

main()