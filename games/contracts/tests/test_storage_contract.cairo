%lang starknet
from starkware.cairo.common.uint256 import Uint256

@contract_interface
namespace StorageContract {
    func increase_balance(amount: Uint256) {
    }

    func get_balance() -> (res: Uint256) {
    }

    func get_id() -> (res: felt) {
    }
}

@external
func test_proxy_contract{syscall_ptr: felt*, range_check_ptr}() {
    alloc_locals;

    local contract_address: felt;
    // We deploy contract and put its address into a local variable. Second argument is calldata array
    %{ ids.contract_address = deploy_contract("./src/storage_contract.cairo", [100, 0, 1]).contract_address %}

    let (res) = StorageContract.get_balance(contract_address=contract_address);
    assert res.low = 100;
    assert res.high = 0;

    let (id) = StorageContract.get_id(contract_address=contract_address);
    assert id = 1;

    StorageContract.increase_balance(contract_address=contract_address, amount=Uint256(50, 0));

    let (res) = StorageContract.get_balance(contract_address=contract_address);
    assert res.low = 150;
    assert res.high = 0;
    return ();
}
