from brownie import accounts, NebulaArbitrator, NebulaEscrow, config

def deploy_arbitrator():
    # account = accounts.add(config["wallets"]["from_key"])
    NebulaArbitrator.deploy({ "from": accounts[10] })

def deploy_escrow():
    # account = accounts.add(config["wallets"]["from_key"])
    # args: payee address (metamask account2), arbitrator address in kleros cad , agreement
    NebulaEscrow.deploy("0x7Ec2bef551d986f086AC01Ee36CeaB4254F78857", "0x279F5ECC6a34219c7a8727500Ff14Ec466d1B328", "Pay payee if goods are delivered", { "from": accounts[10], "amount": 0.001 * (10**18) })

def main():
    deploy_arbitrator()
    # deploy_escrow()
    