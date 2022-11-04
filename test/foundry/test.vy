# @version 0.3.7
"""
@title Yearn Token Vault
@license GNU AGPLv3
@author yearn.finance
@notice
    Yearn Token Vault. Holds an underlying token, and allows users to interact
    with the Yearn ecosystem through Strategies connected to the Vault.
    Vaults are not limited to a single Strategy, they can have as many Strategies
    as can be designed (however the withdrawal queue is capped at 20.)

    Deposited funds are moved into the most impactful strategy that has not
    already reached its limit for assets under management, regardless of which
    Strategy a user's funds end up in, they receive their portion of yields
    generated across all Strategies.

    When a user withdraws, if there are no funds sitting undeployed in the
    Vault, the Vault withdraws funds from Strategies in the order of least
    impact. (Funds are taken from the Strategy that will disturb everyone's
    gains the least, then the next least, etc.) In order to achieve this, the
    withdrawal queue's order must be properly set and managed by the community
    (through governance).

    Vault Strategies are parameterized to pursue the highest risk-adjusted yield.

    There is an "Emergency Shutdown" mode. When the Vault is put into emergency
    shutdown, assets will be recalled from the Strategies as quickly as is
    practical (given on-chain conditions), minimizing loss. Deposits are
    halted, new Strategies may not be added, and each Strategy exits with the
    minimum possible damage to position, while opening up deposits to be
    withdrawn by users. There are no restrictions on withdrawals above what is
    expected under Normal Operation.

    For further details, please refer to the specification:
    https://github.com/iearn-finance/yearn-vaults/blob/main/SPECIFICATION.md
"""

@external
def __init__():
    # do nothing
    return