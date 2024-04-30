=================================================================
GIF DEPLOYMENT
=================================================================

>>> from scripts.instance import GifInstance
>>> instance = GifInstance(accounts[0], accounts[1])
Transaction sent: 0xeb6d0a88a52aad229d45fb69b989e2ce2f9029bd7264fadae67b463af2c0aa38
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  RegistryController.constructor confirmed   Block: 1   Gas used: 1334463 (11.12%)
  RegistryController deployed at: 0x3194cBDC3dbcd3E11a07892e7bA5c3394048Cc87

Transaction sent: 0x6572f7c35284e141455ba50dc33a7b240bd28df0453f9896bc950c39655ed5a6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  CoreProxy.constructor confirmed   Block: 2   Gas used: 635606 (5.30%)
  CoreProxy deployed at: 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6

Transaction sent: 0x0068775eb391ebeb357047a09297652f0d03b34534d8ada0444adc053f9cb9fb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 2
  Transaction confirmed   Block: 3   Gas used: 113902 (0.95%)

Transaction sent: 0xdf366ee88886edba1b0cf5b515d0ab4843b89ac9a62c106fc4fea449ffc9bde3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 3
  Transaction confirmed   Block: 4   Gas used: 114022 (0.95%)

owner 0x66aB6D9362d4F35596279692F0251Db635165871
registry.address 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6
registry.getContract('InstanceOperatorService') 0x66aB6D9362d4F35596279692F0251Db635165871
token BundleToken deploy
Transaction sent: 0x33c8b6cf357d1517ed617b16a8bbf9b35f053134f84bccc7b38985620150997d
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 4
  BundleToken.constructor confirmed   Block: 5   Gas used: 1598511 (13.32%)
  BundleToken deployed at: 0xe0aA552A10d7EC8760Fc6c246D391E698a82dDf9

token BundleToken register
Transaction sent: 0x701978de36dfbb3bd617bdba58a4b332368ab06062567daccace04400db4bfeb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 5
  Transaction confirmed   Block: 6   Gas used: 113938 (0.95%)

token RiskpoolToken deploy
Transaction sent: 0xf54117dcd16d2dc96e1bb8037a63a69260559b6a3e0ec456af7ed03e59b1591e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 6
  RiskpoolToken.constructor confirmed   Block: 7   Gas used: 597828 (4.98%)
  RiskpoolToken deployed at: 0x9E4c14403d7d9A8A782044E86a93CAE09D7B2ac9

token RiskpoolToken register
Transaction sent: 0xbcc573762e5fe24eb318782decaeb9e83c47eb26538cdfab015dfa50783072e8
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 7
  Transaction confirmed   Block: 8   Gas used: 113962 (0.95%)

module Access deploy controller
Transaction sent: 0xe553203c3ab224a9f9e10401874270a9f2d7694fb41357748091b5e1054ac3f5
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 8
  AccessController.constructor confirmed   Block: 9   Gas used: 1256090 (10.47%)
  AccessController deployed at: 0x420b1099B9eF5baba6D92029594eF45E19A04A4A

module Access deploy proxy
Transaction sent: 0xfab217f03e4aa69dc7965fbd18d6120d8c85ad9c15e685ede916e6ef4cfde603
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 9
  CoreProxy.constructor confirmed   Block: 10   Gas used: 552063 (4.60%)
  CoreProxy deployed at: 0xa3B53dDCd2E3fC28e8E130288F2aBD8d5EE37472

module Access (0x416363657373436f6e74726f6c6c657200000000000000000000000000000000) register controller
Transaction sent: 0x03d1a0df46ce80320ed8b786ba24adc36449615bf0532e16afd1a3ab003a3082
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 10
  Transaction confirmed   Block: 11   Gas used: 113998 (0.95%)

module Access (0x4163636573730000000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0x1db3ef86fde86c46f14f7ded8522093d295b59284dcd7ceccf2557ce6e1e8cdb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 11
  Transaction confirmed   Block: 12   Gas used: 113878 (0.95%)

module Component deploy controller
Transaction sent: 0xfa6e63b621b715586009ab7cf278c1206c69ba4b148604e0ce8cf07da897f948
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 12
  ComponentController.constructor confirmed   Block: 13   Gas used: 1957995 (16.32%)
  ComponentController deployed at: 0x2c15A315610Bfa5248E4CbCbd693320e9D8E03Cc

module Component deploy proxy
Transaction sent: 0x88150678db83a81f2b73484097bd94fb9101dd970225c8cf88a0407a32081461
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 13
  CoreProxy.constructor confirmed   Block: 14   Gas used: 517962 (4.32%)
  CoreProxy deployed at: 0xe692Cf21B12e0B2717C4bF647F9768Fa58861c8b

module Component (0x436f6d706f6e656e74436f6e74726f6c6c657200000000000000000000000000) register controller
Transaction sent: 0x511d772b6ca6113ff649037eeb1643fa853b7ffbfd0cc5da6656359b50827bfa
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 14
  Transaction confirmed   Block: 15   Gas used: 114034 (0.95%)

module Component (0x436f6d706f6e656e740000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0x5258ce40750c71a618a7ba08fe8fec528288057ad6a3f2a70a99ece156a0f8dc
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 15
  Transaction confirmed   Block: 16   Gas used: 113914 (0.95%)

module Query deploy controller
Transaction sent: 0xecf24dd1c739ccbfb04dfb82aedc853cb18df16d00bdc9722aaf2b167835c568
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 16
  QueryModule.constructor confirmed   Block: 17   Gas used: 1420951 (11.84%)
  QueryModule deployed at: 0x26f15335BB1C6a4C0B660eDd694a0555A9F1cce3

module Query deploy proxy
Transaction sent: 0x34867ae481b2a9429811992938258e123ccd4a2f8d6943ce0c0cd08779d51dd5
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 17
  CoreProxy.constructor confirmed   Block: 18   Gas used: 545524 (4.55%)
  CoreProxy deployed at: 0xFbD588c72B438faD4Cf7cD879c8F730Faa213Da0

module Query (0x5175657279436f6e74726f6c6c65720000000000000000000000000000000000) register controller
Transaction sent: 0xf2985ae19b8f4c2b31deed4de8c912afa54ce802119bb6013397baa4500a98d9
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 18
  Transaction confirmed   Block: 19   Gas used: 113986 (0.95%)

module Query (0x5175657279000000000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0x2423e0d2986c80cf3ecf64a25f32ed2b51a75a1636727ce8b786d1fd225e1ae7
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 19
  Transaction confirmed   Block: 20   Gas used: 113866 (0.95%)

module License deploy controller
Transaction sent: 0xb7e6fa8e89bb7d0f10392860afa351630d18f249f3b46ff96585c2210237a4be
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 20
  LicenseController.constructor confirmed   Block: 21   Gas used: 421983 (3.52%)
  LicenseController deployed at: 0xdCF93F11ef216cEC9C07fd31dD801c9b2b39Afb4

module License deploy proxy
Transaction sent: 0x146e46ba8b2153bdde5b2de50b5df8cdeeaefbca650e1aa8472ffaffe0c262a6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 21
  CoreProxy.constructor confirmed   Block: 22   Gas used: 545414 (4.55%)
  CoreProxy deployed at: 0xBcb61491F1859f53438918F1A5aFCA542Af9D397

module License (0x4c6963656e7365436f6e74726f6c6c6572000000000000000000000000000000) register controller
Transaction sent: 0xad988fbd65f1663f51201c5198479aa3765eb9935e87a409657cbef2d1e67efd
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 22
  Transaction confirmed   Block: 23   Gas used: 114010 (0.95%)

module License (0x4c6963656e736500000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0xf796700fadaa3809998a5a471ac9d293457f698c496ec9bc19712682376c5215
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 23
  Transaction confirmed   Block: 24   Gas used: 113890 (0.95%)

module Policy deploy controller
Transaction sent: 0xf10fb24f55eba6ea23def1d661e716bb8fd71637cc988d46ab38454b73d59446
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 24
  PolicyController.constructor confirmed   Block: 25   Gas used: 4050054 (33.75%)
  PolicyController deployed at: 0xf9C8Cf55f2E520B08d869df7bc76aa3d3ddDF913

module Policy deploy proxy
Transaction sent: 0x440a8d9b195b3e6ca2b62b555bb101a4665766ba59b3e4fec740141f937a3b78
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 25
  CoreProxy.constructor confirmed   Block: 26   Gas used: 545481 (4.55%)
  CoreProxy deployed at: 0x654f70d8442EA18904FA1AD79114f7250F7E9336

module Policy (0x506f6c696379436f6e74726f6c6c657200000000000000000000000000000000) register controller
Transaction sent: 0x78968ff8ac0cbe2517a627907caa964d44a0b498e9f005a7ba57e41793a1512f
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 26
  Transaction confirmed   Block: 27   Gas used: 113998 (0.95%)

module Policy (0x506f6c6963790000000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0x09b47a59601550a391deded5f046103a7bafbc41523097dbec663ec4ed7470ff
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 27
  Transaction confirmed   Block: 28   Gas used: 113878 (0.95%)

module Bundle deploy controller
Transaction sent: 0xbc1266281615a60ac44f84f47623bab632fc4902cedf6c47ae51ab5b84dff02c
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 28
  BundleController.constructor confirmed   Block: 29   Gas used: 2571791 (21.43%)
  BundleController deployed at: 0xA95916C3D979400C7443961330b3092510a229Ba

module Bundle deploy proxy
Transaction sent: 0x8bbb741b4391f74a66f62caaf2691a4d157dacb192be1405b8418349ce4110ec
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 29
  CoreProxy.constructor confirmed   Block: 30   Gas used: 573064 (4.78%)
  CoreProxy deployed at: 0x42E8D004c84E6B5Bad559D3b5CE7947AADb9E0bc

module Bundle (0x42756e646c65436f6e74726f6c6c657200000000000000000000000000000000) register controller
Transaction sent: 0xf6ffd5ceed906413a7e74c7903d90f7235c30571a287f316b1c83589838edfba
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 30
  Transaction confirmed   Block: 31   Gas used: 113998 (0.95%)

module Bundle (0x42756e646c650000000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0xb222de897693661d62433f38ff075cbdc52a746ee14b90bfa189088757b4ec54
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 31
  Transaction confirmed   Block: 32   Gas used: 113878 (0.95%)

module Pool deploy controller
Transaction sent: 0x9dbd5055499a0712d6e1c39686e83272c5f82f24e8bb70420a2164da4147caa1
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 32
  PoolController.constructor confirmed   Block: 33   Gas used: 2469884 (20.58%)
  PoolController deployed at: 0x724Ca58E1e6e64BFB1E15d7Eec0fe1E5f581c7bD

module Pool deploy proxy
Transaction sent: 0x901c0f78726aa156cb12c5f1529c32ab2247e907462c72cdebb18f1b7b61fcb3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 33
  CoreProxy.constructor confirmed   Block: 34   Gas used: 600585 (5.00%)
  CoreProxy deployed at: 0x34b97ffa01dc0DC959c5f1176273D0de3be914C1

module Pool (0x506f6f6c436f6e74726f6c6c6572000000000000000000000000000000000000) register controller
Transaction sent: 0xfa8e71e1176781d879e8642cb2b3d166ee262cd761ff7fca0a43671ba2b5df84
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 34
  Transaction confirmed   Block: 35   Gas used: 113974 (0.95%)

module Pool (0x506f6f6c00000000000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0xb802147857a75a70e8154450cd80e715ee76ebbe0f873746bb3b93fa8f95542e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 35
  Transaction confirmed   Block: 36   Gas used: 113854 (0.95%)

module Treasury deploy controller
Transaction sent: 0x83bc11023fcd30d477cb4fe2e5b9cbdaa995afaed8b86e52c33eef3ba559e61d
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 36
  TreasuryModule.constructor confirmed   Block: 37   Gas used: 4015425 (33.46%)
  TreasuryModule deployed at: 0x741e3E1f81041c62C2A97d0b6E567AcaB09A6232

module Treasury deploy proxy
Transaction sent: 0xb9581bd0101075bd6c4fc9425c65fd210be23c28c7c41da0eb7c5ef9129d9a98
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 37
  CoreProxy.constructor confirmed   Block: 38   Gas used: 628203 (5.24%)
  CoreProxy deployed at: 0x4B0FccF53589c1F185B35db88bB315a0bBF9a3e0

module Treasury (0x5472656173757279436f6e74726f6c6c65720000000000000000000000000000) register controller
Transaction sent: 0x5cb3c6864747ee415feb8da14768eed679f91780627ce0e1a53e94ba020c1b24
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 38
  Transaction confirmed   Block: 39   Gas used: 114022 (0.95%)

module Treasury (0x5472656173757279000000000000000000000000000000000000000000000000) register proxy
Transaction sent: 0x330e30e5fcc5aa8c4798b357bbff4b0c3f717813c0c53032172437c89efb060d
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 39
  Transaction confirmed   Block: 40   Gas used: 113902 (0.95%)

Transaction sent: 0x91898e93b2f8d66ccea364643cb35801a3612ff219d1431a364fa0d75b9d7684
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 40
  PolicyDefaultFlow.constructor confirmed   Block: 41   Gas used: 2890678 (24.09%)
  PolicyDefaultFlow deployed at: 0x0AC45e945A008D3fc19da8f591be8601C1F63130

Transaction sent: 0x0e51fb5d88aaec89e518d3e11c38d0e353ea40b9443a4c9e9ae4c9cab3f4bcc6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 41
  Transaction confirmed   Block: 42   Gas used: 113998 (0.95%)

module InstanceService deploy controller
Transaction sent: 0x1d8cf0d0eb496b579259489bf6f08c4d6eff72d9bc3b9294e85b8d221ff15acf
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 42
  InstanceService.constructor confirmed   Block: 43   Gas used: 2663832 (22.20%)
  InstanceService deployed at: 0x0C60536783db9ED5A2B216970B10FF2243d317dD

module InstanceService deploy proxy
Transaction sent: 0x895e4dd94fb6f2f25b95147cd835c8b2b65f07d35c38094a9f5570256664fb08
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 43
  CoreProxy.constructor confirmed   Block: 44   Gas used: 847294 (7.06%)
  CoreProxy deployed at: 0x0e19E87b363DD7a3af5c45C95ab6885367251B94

module InstanceService (0x496e7374616e636553657276696365436f6e74726f6c6c657200000000000000) register controller
Transaction sent: 0xd533088b8ce31f8be05743fa9febfea9d061e3c8ccab79b732b7251ba5f19ace
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 44
  Transaction confirmed   Block: 45   Gas used: 114106 (0.95%)

module InstanceService (0x496e7374616e6365536572766963650000000000000000000000000000000000) register proxy
Transaction sent: 0x8d5dcabe9772c4b3e6514554a2c22d1cc81e12594a9e2d257cb58481ba53b90b
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 45
  Transaction confirmed   Block: 46   Gas used: 113986 (0.95%)

module ComponentOwnerService deploy controller
Transaction sent: 0x937632d059bf39aca6f1382af41c25ca9ceb9c9ff96d2da7640b2b35c067cb7e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 46
  ComponentOwnerService.constructor confirmed   Block: 47   Gas used: 1470762 (12.26%)
  ComponentOwnerService deployed at: 0x8BE16B874F47371C42498b499837Ed87D7661E86

module ComponentOwnerService deploy proxy
Transaction sent: 0x5a374d394cbf67c4d9a70361fb68711f3569b4a9984314f898dbcbe7f4a5db61
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 47
  CoreProxy.constructor confirmed   Block: 48   Gas used: 545480 (4.55%)
  CoreProxy deployed at: 0x1aa96efd2B002541E830CB7f60e473AA24e31F9A

module ComponentOwnerService (0x436f6d706f6e656e744f776e657253657276696365436f6e74726f6c6c657200) register controller
Transaction sent: 0x7fb272dfa2da722a39adbf4aa1d69e610c471e01c77f895251f38a7909c8ac98
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 48
  Transaction confirmed   Block: 49   Gas used: 114178 (0.95%)

module ComponentOwnerService (0x436f6d706f6e656e744f776e6572536572766963650000000000000000000000) register proxy
Transaction sent: 0xbdebda0df69691dc0729aff6056f8d2d710edd93a9a75d22802bfd98977f29a9
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 49
  Transaction confirmed   Block: 50   Gas used: 114046 (0.95%)

module OracleService deploy controller
Transaction sent: 0x983c4e4526d8cfa875e8e9c0f273691ca842432111a62c004f6ec0fcf8344a55
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 50
  OracleService.constructor confirmed   Block: 51   Gas used: 369302 (3.08%)
  OracleService deployed at: 0xD537bF4b795b7D07Bd5F4bAf7017e3ce8360B1DE

module OracleService deploy proxy
Transaction sent: 0x6be9e7252654600567930537700cef8547bb13207ea5da7528328c1feec7b5f6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 51
  CoreProxy.constructor confirmed   Block: 52   Gas used: 545414 (4.55%)
  CoreProxy deployed at: 0x70bC6D873D110Da59a9c49E7485a27B0F605E5db

module OracleService (0x4f7261636c6553657276696365436f6e74726f6c6c6572000000000000000000) register controller
Transaction sent: 0xc354a0d590e0f6d46efede8b6be9b54120a2b93a2e3cad172ffecfb3a42fbd4e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 52
  Transaction confirmed   Block: 53   Gas used: 114082 (0.95%)

module OracleService (0x4f7261636c655365727669636500000000000000000000000000000000000000) register proxy
Transaction sent: 0x609d946d9d837e54d6a81ab90206eb7c308123379f27c32f8675ad4f7a64ea0e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 53
  Transaction confirmed   Block: 54   Gas used: 113962 (0.95%)

module RiskpoolService deploy controller
Transaction sent: 0x267ca373d43e6ec227274d8ffec12b6f85f3d3fa1ed21e00eabc980d5fd745a3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 54
  RiskpoolService.constructor confirmed   Block: 55   Gas used: 3595391 (29.96%)
  RiskpoolService deployed at: 0xEfE66132727f3831AB4E020357B5Bf615076Df6A

module RiskpoolService deploy proxy
Transaction sent: 0x7ba566ed846b784c51f6ebd314d9b0700b94b27690fd3566bd171a67b24aec26
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 55
  CoreProxy.constructor confirmed   Block: 56   Gas used: 628147 (5.23%)
  CoreProxy deployed at: 0xEFDE7eC452f9A203559896F64267809E248D044f

module RiskpoolService (0x5269736b706f6f6c53657276696365436f6e74726f6c6c657200000000000000) register controller
Transaction sent: 0xf1803f2883b780de8a864c6dd606ca27fb4528eb31072768d8bd1cdd876c3e61
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 56
  Transaction confirmed   Block: 57   Gas used: 114106 (0.95%)

module RiskpoolService (0x5269736b706f6f6c536572766963650000000000000000000000000000000000) register proxy
Transaction sent: 0x8fa51720aa8ffea40b232e4ec12bace2449fbdb960619846fcaadb857beb89c5
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 57
  Transaction confirmed   Block: 58   Gas used: 113986 (0.95%)

Transaction sent: 0x51e1a057946a39a5ee86bc063f5f4bdccead49696d92ce903873d09f75188bc3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 58
  ProductService.constructor confirmed   Block: 59   Gas used: 293570 (2.45%)
  ProductService deployed at: 0xa5659Fa683b71C907cd346397c694b93aFF40b51

Transaction sent: 0x28dd7e670d645d91ced01fc80445ae8acd6b1116a5b7e450dda7ce79f3a965d3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 59
  Transaction confirmed   Block: 60   Gas used: 113974 (0.95%)

module InstanceOperatorService deploy controller
Transaction sent: 0x5e093e8b1a64779a7d90742c232e578c4ee482439ece0be49101cc4a19ab8c5b
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 60
  InstanceOperatorService.constructor confirmed   Block: 61   Gas used: 1645861 (13.72%)
  InstanceOperatorService deployed at: 0xA83Fad7514B39b12C0bAcA71e0A7cc63D2Ff1941

module InstanceOperatorService deploy proxy
Transaction sent: 0x1a911f5441b814b5b82c1220e69014596a0b94b8cdb2dfb6f1939a29e9413aff
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 61
  CoreProxy.constructor confirmed   Block: 62   Gas used: 779085 (6.49%)
  CoreProxy deployed at: 0x64B334435888bb5E44D890a7B319981c4Bb4B47d

module InstanceOperatorService (0x496e7374616e63654f70657261746f7253657276696365436f6e74726f6c6c65) register controller
Transaction sent: 0x4f1c6ff8ca273d8efcc91cbd5eff15aef553ebc283b913e796e2e2deef9f4270
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 62
  Transaction confirmed   Block: 63   Gas used: 114190 (0.95%)

module InstanceOperatorService (0x496e7374616e63654f70657261746f7253657276696365000000000000000000) register proxy
Transaction sent: 0x24425e0d40ebd37811949ec03631ac52727ad59315cb8e795d528306b9d353a0
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 63
  Transaction confirmed   Block: 64   Gas used: 46286 (0.39%)

Transaction sent: 0xfa7496520e14077b2bce8ecbc3e4f224770dd571e59a90f764a96c9931e8a997
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 64
  Transaction confirmed   Block: 65   Gas used: 58609 (0.49%)





===================================================================
PRODUCT DEPLOYMENT
===================================================================


>>> (customer, customer2, product, oracle, riskpool, riskpoolWallet, investor, usdc, instance, instanceService, instanceOperator, bundleId, processI 
d, d) = all_in_1(deploy_all=False)
Transaction sent: 0x43579afce00f41307244c9a1ddfa029f0bc64bfddcc2b3a2588ea132d6f56b02
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 65
  Usdc.constructor confirmed   Block: 66   Gas used: 662000 (5.52%)
  Usdc deployed at: 0xFd87ceEa79b211268Fb182a48E43644543c08709

found registry in gif_instance_address.txt: 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6
owner 0x66aB6D9362d4F35596279692F0251Db635165871
registry.address 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6
registry.getContract('InstanceOperatorService') 0x64B334435888bb5E44D890a7B319981c4Bb4B47d
====== token setup ======
- token USDC 0xFd87ceEa79b211268Fb182a48E43644543c08709
====== deploy product/oracle/riskpool "Fire" ======
------ setting up oracle ------
1) grant oracle provider role 0xd26b4cd59ffa91e4599f3d18b02fcd5ffb06e03216f3ee5f25f68dc75cbbbaa2 to oracle provider 0x807c47A89F720fe4Ee9b8343c286Fc886f43191b
Transaction sent: 0xc5fa27ab1fd984792c15a26725bb72b8286e04306f0d0fb91b2303e1305b7106
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 66
  Transaction confirmed   Block: 67   Gas used: 126248 (1.05%)

2) deploy oracle Fire_1714065983_Oracle by oracle provider 0x807c47A89F720fe4Ee9b8343c286Fc886f43191b
Transaction sent: 0xaeb19a462ecd0cfa3b70b05a3ffb259209dc05b8963e6d21fa508e1350090494
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  FireOracle.constructor confirmed   Block: 68   Gas used: 1011392 (8.43%)
  FireOracle deployed at: 0x68961d58ddc8D04a2Eb3C49720A62972Fc3C4B23

3) oracle 0x68961d58ddc8D04a2Eb3C49720A62972Fc3C4B23 proposing to instance by oracle provider 0x807c47A89F720fe4Ee9b8343c286Fc886f43191b
Transaction sent: 0xc6a5c1d158342c4ebb4a6291fbdc8899cb67eac29426145cfdd8689ba44cbb2c
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  Transaction confirmed   Block: 69   Gas used: 284733 (2.37%)

4) approval of oracle id 1 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x701a03e2df6528e1169b80857b4e05d9ab8c1588fa17936d9c8078553e9d064b
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 67
  Transaction confirmed   Block: 70   Gas used: 63232 (0.53%)

------ setting up riskpool ------
1) grant riskpool keeper role 0x3c4cdb47519f2f89924ebeb1ee7a8a43b8b00120826915726460bb24576012fd to riskpool keeper 0x0063046686E46Dc6F15918b61AE2B121458534a5
Transaction sent: 0x0ca54d91569d1f5aac6a6edb0d6a6fcdad3e007b0c75b96d5c17b4ce57c4ca15
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 68
  Transaction confirmed   Block: 71   Gas used: 126236 (1.05%)

2) deploy riskpool Fire_1714065983_Riskpool by riskpool keeper 0x0063046686E46Dc6F15918b61AE2B121458534a5
Transaction sent: 0xf27fb17fe8a7a90c2b45729c81485cf8a9aa44f08c7b383da0d18cc66cbd1096
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  FireRiskpool.constructor confirmed   Block: 72   Gas used: 2743734 (22.86%)
  FireRiskpool deployed at: 0x1596Ff8ED308a83897a731F3C1e814B19E11D68c

3) riskpool 0x1596Ff8ED308a83897a731F3C1e814B19E11D68c proposing to instance by riskpool keeper 0x0063046686E46Dc6F15918b61AE2B121458534a5
Transaction sent: 0x4ab7fcdf5d3e2a2cba3a49a64b8c9b6455dafcc134ec1fabfe436c4bcb14f1e3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  Transaction confirmed   Block: 73   Gas used: 525179 (4.38%)

4) approval of riskpool id 2 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0xa95a33014fca6a9f14a02b4d178a63addd71e90cac8dd917deb45cfde66d3c12
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 69
  Transaction confirmed   Block: 74   Gas used: 61343 (0.51%)

5) set max number of bundles to 10 by riskpool keeper 0x0063046686E46Dc6F15918b61AE2B121458534a5
Transaction sent: 0x67555ac68f3c490486bd9a018076b5ea28f5966ba12ed4c955a09016f8c110a6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 2
  FireRiskpool.setMaximumNumberOfActiveBundles confirmed   Block: 75   Gas used: 63314 (0.53%)

6) riskpool wallet 0x21b42413bA931038f35e7A5224FaDb065d297Ba3 set for riskpool id 2 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x63922347d8aa8c05906e1fdb5d0e860b1b4bb02fee2141180112846314f76a8c
  Transaction confirmed   Block: 76   Gas used: 70524 (0.59%)

7) creating capital fee spec (fixed: 0, fractional: 0) for riskpool id 2 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
8) setting capital fee spec by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x6b604e164c11a8eef10095bb81a809bfa5e39682dc3df48636619078efdec433
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 71
  Transaction confirmed   Block: 77   Gas used: 110011 (0.92%)

------ setting up product ------
1) grant product owner role 0xe984cfd1d1fa34f80e24ddb2a60c8300359d79eee44555bc35c106eb020394cd to product owner 0x844ec86426F076647A5362706a04570A5965473B      
Transaction sent: 0xb01ee26102890fda7f4f9c29cf5d06c4279cda6d11dca65478ec0a41f051c680
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 72
  Transaction confirmed   Block: 78   Gas used: 126236 (1.05%)

2) deploy product Fire_1714065983_Product by product owner 0x844ec86426F076647A5362706a04570A5965473B
Transaction sent: 0x0e3336c3fcee57fff03d051954262b0a31c5f4911b0b9bc65e6b473b187d6929
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  FireProduct.constructor confirmed   Block: 79   Gas used: 2041368 (17.01%)
  FireProduct deployed at: 0x7cD60DF26dA0F591797A3370d09595eb95110C0e

3) product 0x7cD60DF26dA0F591797A3370d09595eb95110C0e proposing to instance by product owner 0x844ec86426F076647A5362706a04570A5965473B
Transaction sent: 0xf3a753eb328f66a060fbf32c16094cc5525f73c6dc4af70e4f26ade2d6e378cb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  Transaction confirmed   Block: 80   Gas used: 267159 (2.23%)

4) approval of product id 3 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x3829276338df4d6299b39e25a34547aaf0e580ceec490aa09120d51f3848851c
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 73
  Transaction confirmed   Block: 81   Gas used: 139014 (1.16%)

5) setting erc20 product token 0xFd87ceEa79b211268Fb182a48E43644543c08709 for product id 3 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x1bb35964d190a7ea8ab5f215610d78e1df7b300f80ab66aea6ea590c47f066bb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 74
  Transaction confirmed   Block: 82   Gas used: 98959 (0.82%)

6) creating premium fee spec (fixed: 0, fractional: 0.1) for product id 3 by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
7) setting premium fee spec by instance operator 0x66aB6D9362d4F35596279692F0251Db635165871
Transaction sent: 0x276538b700c6a30d7b50cf3615d7098e773b835cf2411b33943baa04be62979e
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 75
  Transaction confirmed   Block: 83   Gas used: 129210 (1.08%)

--- create risk bundle and policy ---
Transaction sent: 0x873df861a13532477f8d6100218ccfee7aa60c4599f144527645aecea5ec53f6
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  Usdc.approve confirmed   Block: 84   Gas used: 44227 (0.37%)

Transaction sent: 0xef63740a23f22fe502b0c6c48ece3efa6c9beb4a295cfa813935ef11e22484b1
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 76
  Usdc.transfer confirmed   Block: 85   Gas used: 51034 (0.43%)

Transaction sent: 0xeb56c265e1f0b31eab5c95454d65d11a44f13d17a78a019ae2a14850997740d3
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  Usdc.approve confirmed   Block: 86   Gas used: 44155 (0.37%)

Transaction sent: 0x62d52aba1b993b0c5bafe1719df81ec5e87c788315afc8400cd0aadc02bbba27
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  FireRiskpool.createBundle confirmed   Block: 87   Gas used: 693518 (5.78%)

Transaction sent: 0x9ea4e5b191ac8b1be769d37239931a674f6c01a5b7b5c2900b10c7a8fc6ea86c
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 77
  Usdc.transfer confirmed   Block: 88   Gas used: 51034 (0.43%)

Transaction sent: 0xab861a25316e0024cbf800d3c33b4513cd6e6cd76ce736e22241f34b23dcc0fb
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 0
  Usdc.approve confirmed   Block: 89   Gas used: 44155 (0.37%)

Transaction sent: 0xaed1600b90716051ca8537e6d0c2849feb0b7cfadffb3a3a39d3c785c1a657fe
  Gas price: 1e-09 gwei   Gas limit: 12000000   Nonce: 1
  FireProduct.applyForPolicy confirmed   Block: 90   Gas used: 1937787 (16.15%)



=================================================================================
VERIFY
==================================================================================

>>> verify_deploy(d, usdc, product)
owner 0x66aB6D9362d4F35596279692F0251Db635165871
registry.address 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6
registry.getContract('InstanceOperatorService') 0x64B334435888bb5E44D890a7B319981c4Bb4B47d
Registry OK 0x602C71e4DAC47a042Ee7f46E0aee17F94A3bA0B6
InstanceOperator OK 0x66aB6D9362d4F35596279692F0251Db635165871
InstanceWallet OK 0x33A4622B82D4c04a53e170c638B944ce27cffce3
RiskpoolId OK 2
RiskpoolType OK 2
RiskpoolState OK 3
RiskpoolContract OK 0x1596Ff8ED308a83897a731F3C1e814B19E11D68c
RiskpoolKeeper OK 0x0063046686E46Dc6F15918b61AE2B121458534a5
RiskpoolWallet OK 0x21b42413bA931038f35e7A5224FaDb065d297Ba3
RiskpoolBalance OK 1004500000000
RiskpoolToken OK 0xFd87ceEa79b211268Fb182a48E43644543c08709
ProductId OK 3
ProductType OK 1
ProductState OK 3
ProductContract OK 0x7cD60DF26dA0F591797A3370d09595eb95110C0e
ProductOwner OK 0x844ec86426F076647A5362706a04570A5965473B
ProductToken OK 0xFd87ceEa79b211268Fb182a48E43644543c08709
ProductOracle OK 1
ProductRiskpool OK 2
InstanceWalletBalance 500.00
RiskpoolWalletTVL 100000.00
RiskpoolWalletCapacity 900000.00
RiskpoolWalletBalance 1004500.00
RiskpoolBundles 1
ProductApplications 1
--- inspect_bundles(d) ---
i owner riskpool bundle token capital locked capacity
0 0x46C..Ae84 2 1 USDC 1000000.0 100000.0 900000.0
--- inspect_applications(d) ---
i customer product id type state object premium suminsured
0 0xA86..F69C 3 0xc2cda25b6f2e329162045a5198ea2e71c4a015cf9f918e0f2023a487fd439e1d policy 0 5000.0 100000.0