Make sure you have IArbitrable.sol and IAbitrator.sol copied to your gif-interfaces dependency
eg:
In windows, .brownie folder in users directory -> etherisc -> gif-interfaces
copy IArbitrator.sol and IArbitrable.sol to /gif-interface/contracts/components/

The interfaces are in kleros/kleros-interfaces.sol . It is kept for reference (can be deleted once movd to dependencies folder)

brownie compile --all --size
(24KB)

brownie console

1. Deploy GIF

from scripts.instance import GifInstance

instance = GifInstance(accounts[0], accounts[1])

f = open("./gif_instance_address.txt", "w")

f.writelines("registry=%s\n" % (instance.getRegistry().address))

f.close()

2. Deploy product

from scripts.deploy_nebula import all_in_1, verify_deploy, create_bundle, create_policy, help

(customer, customer2, product, oracle, riskpool, riskpoolWallet, investor, usdc, instance, instanceService, instanceOperator, bundleId, processId, d) = all_in_1(deploy_all=False)

3. Setup owner, nominee accounts

accounts.add()

owner = accounts[-1]

accounts.add()

nominee = accounts[-1]

4. Fund owner and nominee accounts and product contract to pay gas fees

accounts[10].transfer(owner, "5 ether")

accounts[10].transfer(nominee, "2 ether")

accounts[10].transfer(product, "3 ether")

5. Transfer usdc tokens to owner accoutn and approve treasury to pay premium

usdc.transfer(owner, 10 \*\* 8, { "from": instanceOperator })

usdc.approve(instanceService.getTreasuryAddress(), 10 \*\* 8, { "from": owner })

6. Add owner and nominee to metamask and import usdc token

owner.private_key

nominee.private_key

5. Apply and underwrite policy

policy_tx = product.applyForPolicy("dpk@abc.com", 20, 1, nominee.address, "LIFE", 10 \*\* 7, { "from": owner })

processId = policy_tx.events['LogApplicationCreated'][0]['processId']

6. Raise claim

tx_claim = product.handleClaim(processId, { "from": nominee })

Note: to get tx if forgot to store it

from brownie.network.transaction import TransactionReceipt
tx = TransactionReceipt(yx_hash)

7. Get escrow and arbitrator created

ec_addr = tx_claim.events["LogTreasuryPayoutTransferred"][0]["escrow"]

escrow = NebulaEscrow.at(ec_addr)
arbitrator = NebulaArbitrator.at(product.arbitrator())

Note: escrow.status() initially 0

arbitrator.owner() is the product

escrow.payee() is nominee
escrow.payer() is riskpoolWallet

usdc.balanceOf(escrow) is sumInsured
usdc.allowance(escrow, arbitrator) is sumInsured

8. Payer reclaim funds and pay the arbitration fee

escrow.reclaimFunds({"from": riskpoolWallet, "amount": 10 \*\* 15 })
escrow.status() is now 1 ie Reclaimed

9. Payee should deposit arbitration fee beofre window expires

escrow.depositArbitrationFeeForPayee({"from": nominee, "amount": 10 \*\* 15 })

escrow.status() is now 2 ie Disputed

10. Kleros court can see the disputes for this arbitrator

Once period is over. Arbitrator can rule
tx_rule = arbitrator.rule(0, 2 , { "from": product })

escrow.status() is now 3 , ie Resolved
usdc.balanceOf(escrow) is 0
escrow.balance() is also 0

nominee gets sumInsured tokens
