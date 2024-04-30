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

>>> (customer, customer2, product, oracle, riskpool, riskpoolWallet, investor, usdc, instance, instanceService, instanceOperator, bundleId, processId, d) = all_in_1(deploy_all=False)

>>> verify_deploy(d, usdc, product)




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


instanceService.getPolicy(processId).dict()

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