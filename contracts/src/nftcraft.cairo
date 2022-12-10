%lang starknet


from warplib.memory import wm_alloc, wm_write_256, wm_read_felt, wm_read_256, wm_dyn_array_length
from starkware.cairo.common.uint256 import Uint256, uint256_sub, uint256_add, uint256_lt, uint256_eq
from starkware.cairo.common.dict import dict_write, dict_read
from starkware.cairo.common.alloc import alloc
from warplib.maths.utils import narrow_safe
from warplib.maths.int_conversions import warp_uint256
from warplib.maths.external_input_check_ints import warp_external_input_check_int256, warp_external_input_check_int8, warp_external_input_check_int32
from warplib.maths.external_input_check_address import warp_external_input_check_address
from warplib.maths.external_input_check_bool import warp_external_input_check_bool
from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from warplib.maths.lt import warp_lt256
from warplib.maths.add import warp_add256
from warplib.maths.sub import warp_sub256
from warplib.maths.gt import warp_gt256
from starkware.starknet.common.syscalls import get_contract_address, get_caller_address
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.default_dict import default_dict_new, default_dict_finalize
from warplib.maths.neq import warp_neq
from warplib.maths.eq import warp_eq
from warplib.maths.sub_unsafe import warp_sub_unsafe256
from warplib.maths.add_unsafe import warp_add_unsafe256


struct cd_dynarray_felt{
     len : felt ,
     ptr : felt*,
}

func WM0_d_arr{range_check_ptr, warp_memory: DictAccess*}() -> (loc: felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x2, 0x0));
wm_write_256{warp_memory=warp_memory}(start, Uint256(0x0, 0x0));
    return (start,);
}

func WM1_d_arr{range_check_ptr, warp_memory: DictAccess*}(e0: felt, e1: felt, e2: felt, e3: felt, e4: felt, e5: felt, e6: felt, e7: felt) -> (loc: felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0xa, 0x0));
wm_write_256{warp_memory=warp_memory}(start, Uint256(0x8, 0x0));
dict_write{dict_ptr=warp_memory}(start + 2, e0);
dict_write{dict_ptr=warp_memory}(start + 3, e1);
dict_write{dict_ptr=warp_memory}(start + 4, e2);
dict_write{dict_ptr=warp_memory}(start + 5, e3);
dict_write{dict_ptr=warp_memory}(start + 6, e4);
dict_write{dict_ptr=warp_memory}(start + 7, e5);
dict_write{dict_ptr=warp_memory}(start + 8, e6);
dict_write{dict_ptr=warp_memory}(start + 9, e7);
    return (start,);
}

func WM2_d_arr{range_check_ptr, warp_memory: DictAccess*}(e0: felt, e1: felt, e2: felt, e3: felt) -> (loc: felt){
    alloc_locals;
    let (start) = wm_alloc(Uint256(0x6, 0x0));
wm_write_256{warp_memory=warp_memory}(start, Uint256(0x4, 0x0));
dict_write{dict_ptr=warp_memory}(start + 2, e0);
dict_write{dict_ptr=warp_memory}(start + 3, e1);
dict_write{dict_ptr=warp_memory}(start + 4, e2);
dict_write{dict_ptr=warp_memory}(start + 5, e3);
    return (start,);
}

func wm_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(mem_loc: felt) -> (retData: cd_dynarray_felt){
    alloc_locals;
    let (len_256) = wm_read_256(mem_loc);
    let (ptr : felt*) = alloc();
    let (len_felt) = narrow_safe(len_256);
    wm_to_calldata1(len_felt, ptr, mem_loc + 2);
    return (cd_dynarray_felt(len=len_felt, ptr=ptr),);
}


func wm_to_calldata1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(len: felt, ptr: felt*, mem_loc: felt) -> (){
    alloc_locals;
    if (len == 0){
         return ();
    }
let (mem_read0) = wm_read_felt(mem_loc);
assert ptr[0] = mem_read0;
    wm_to_calldata1(len=len - 1, ptr=ptr + 1, mem_loc=mem_loc + 1);
    return ();
}

func wm_to_storage0_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(storage_name: felt, mem_loc : felt, length: Uint256) -> (){
    alloc_locals;
    if (length.low == 0 and length.high == 0){
        return ();
    }
    let (index) = uint256_sub(length, Uint256(1,0));
    let (storage_loc) = WARP_DARRAY0_felt.read(storage_name, index);
    let mem_loc = mem_loc - 1;
    if (storage_loc == 0){
        let (storage_loc) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(storage_loc + 1);
        WARP_DARRAY0_felt.write(storage_name, index, storage_loc);
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }else{
    let (copy) = dict_read{dict_ptr=warp_memory}(mem_loc);
    WARP_STORAGE.write(storage_loc, copy);
    return wm_to_storage0_elem(storage_name, mem_loc, index);
    }
}
func wm_to_storage0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(loc : felt, mem_loc : felt) -> (loc : felt){
    alloc_locals;
    let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
    let (mem_length) = wm_dyn_array_length(mem_loc);
    WARP_DARRAY0_felt_LENGTH.write(loc, mem_length);
    let (narrowedLength) = narrow_safe(mem_length);
    wm_to_storage0_elem(loc, mem_loc + 2 + 1 * narrowedLength, mem_length);
    let (lesser) = uint256_lt(mem_length, length);
    if (lesser == 1){
       WS0_DYNAMIC_ARRAY_DELETE_elem(loc, mem_length, length);
       return (loc,);
    }else{
       return (loc,);
    }
}

func WS0_DYNAMIC_ARRAY_DELETE_elem{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt, index : Uint256, length : Uint256){
     alloc_locals;
     let (stop) = uint256_eq(index, length);
     if (stop == 1){
        return ();
     }
     let (elem_loc) = WARP_DARRAY0_felt.read(loc, index);
    WS1_DELETE(elem_loc);
     let (next_index, _) = uint256_add(index, Uint256(0x1, 0x0));
     return WS0_DYNAMIC_ARRAY_DELETE_elem(loc, next_index, length);
}
func WS0_DYNAMIC_ARRAY_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt){
   alloc_locals;
   let (length) = WARP_DARRAY0_felt_LENGTH.read(loc);
   WARP_DARRAY0_felt_LENGTH.write(loc, Uint256(0x0, 0x0));
   return WS0_DYNAMIC_ARRAY_DELETE_elem(loc, Uint256(0x0, 0x0), length);
}

func WS1_DELETE{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt){
    WARP_STORAGE.write(loc, 0);
    return ();
}

func WS0_READ_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = readId(loc);
    return (read0,);
}

func WS1_READ_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: Uint256){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    let (read1) = WARP_STORAGE.read(loc + 1);
    return (Uint256(low=read0,high=read1),);
}

func WS2_READ_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) ->(val: felt){
    alloc_locals;
    let (read0) = WARP_STORAGE.read(loc);
    return (read0,);
}

func ws_dynamic_array_to_calldata0_write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(
   loc : felt,
   index : felt,
   len : felt,
   ptr : felt*) -> (ptr : felt*){
   alloc_locals;
   if (len == index){
       return (ptr,);
   }
   let (index_uint256) = warp_uint256(index);
   let (elem_loc) = WARP_DARRAY0_felt.read(loc, index_uint256);
   let (elem) = WS2_READ_felt(elem_loc);
   assert ptr[index] = elem;
   return ws_dynamic_array_to_calldata0_write(loc, index + 1, len, ptr);
}
func ws_dynamic_array_to_calldata0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc : felt) -> (dyn_array_struct : cd_dynarray_felt){
   alloc_locals;
   let (len_uint256) = WARP_DARRAY0_felt_LENGTH.read(loc);
   let len = len_uint256.low + len_uint256.high*128;
   let (ptr : felt*) = alloc();
   let (ptr : felt*) = ws_dynamic_array_to_calldata0_write(loc, 0, len, ptr);
   let dyn_array_struct = cd_dynarray_felt(len, ptr);
   return (dyn_array_struct,);
}

func WS_WRITE0{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: Uint256) -> (res: Uint256){
    WARP_STORAGE.write(loc, value.low);
    WARP_STORAGE.write(loc + 1, value.high);
    return (value,);
}

func WS_WRITE1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt, value: felt) -> (res: felt){
    WARP_STORAGE.write(loc, value);
    return (value,);
}

func extern_input_check0{range_check_ptr : felt}(len: felt, ptr : felt*) -> (){
    alloc_locals;
    if (len == 0){
        return ();
    }
warp_external_input_check_int8(ptr[0]);
   extern_input_check0(len = len - 1, ptr = ptr + 1);
    return ();
}

@storage_var
func WARP_DARRAY0_felt(name: felt, index: Uint256) -> (resLoc : felt){
}
@storage_var
func WARP_DARRAY0_felt_LENGTH(name: felt) -> (index: Uint256){
}

@storage_var
func WARP_MAPPING0(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS0_INDEX_Uint256_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING0.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING0.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING1(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS1_INDEX_Uint256_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING1.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING1.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING2(name: felt, index: Uint256) -> (resLoc : felt){
}
func WS2_INDEX_Uint256_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: Uint256) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING2.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING2.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING3(name: felt, index: felt) -> (resLoc : felt){
}
func WS3_INDEX_felt_to_Uint256{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING3.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 2);
        WARP_MAPPING3.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING4(name: felt, index: felt) -> (resLoc : felt){
}
func WS4_INDEX_felt_to_felt{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING4.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING4.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}

@storage_var
func WARP_MAPPING5(name: felt, index: felt) -> (resLoc : felt){
}
func WS5_INDEX_felt_to_warp_id{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(name: felt, index: felt) -> (res: felt){
    alloc_locals;
    let (existing) = WARP_MAPPING5.read(name, index);
    if (existing == 0){
        let (used) = WARP_USED_STORAGE.read();
        WARP_USED_STORAGE.write(used + 1);
        WARP_MAPPING5.write(name, index, used);
        return (used,);
    }else{
        return (existing,);
    }
}


// Contract Def NFTCraft


@event
func ApprovalForAll_17307eab(owner : felt, operator : felt, approved : felt){
}


@event
func Approval_8c5be1e5(owner : felt, spender : felt, id : Uint256){
}


@event
func Transfer_ddf252ad(__warp_6_from : felt, to : felt, id : Uint256){
}


@event
func Set_1d170fcf(x : Uint256, y : Uint256, z : Uint256, modelId : Uint256, textureId : Uint256, tokenId : Uint256){
}

namespace NFTCraft{

    // Dynamic variables - Arrays and Maps

    const __warp_0_locations = 1;

    const __warp_1_modelIds = 2;

    const __warp_2_textureIds = 3;

    const __warp_0_name = 4;

    const __warp_1_symbol = 5;

    const __warp_2__ownerOf = 6;

    const __warp_3__balanceOf = 7;

    const __warp_4_getApproved = 8;

    const __warp_5_isApprovedForAll = 9;

    // Static variables

    const length = 3;

    const __warp_3_totalSupply = 5;


    func __warp_constructor_3()-> (){
    alloc_locals;


        
        
        
        return ();

    }


    func set_eccd65dc_if_part1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_9_tokenId : Uint256, __warp_4_x : Uint256, __warp_5_y : Uint256, __warp_6_z : Uint256, __warp_7_modelId : Uint256, __warp_8_textureId : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_15) = get_contract_address();
        
        _mint_4e6ec247(__warp_se_15, __warp_9_tokenId);
        
        let (__warp_se_16) = WS1_INDEX_Uint256_to_warp_id(__warp_0_locations, __warp_4_x);
        
        let (__warp_se_17) = WS0_READ_warp_id(__warp_se_16);
        
        let (__warp_se_18) = WS1_INDEX_Uint256_to_warp_id(__warp_se_17, __warp_5_y);
        
        let (__warp_se_19) = WS0_READ_warp_id(__warp_se_18);
        
        let (__warp_se_20) = WS0_INDEX_Uint256_to_Uint256(__warp_se_19, __warp_6_z);
        
        WS_WRITE0(__warp_se_20, __warp_9_tokenId);
        
        let (__warp_se_21) = WS0_INDEX_Uint256_to_Uint256(__warp_1_modelIds, __warp_9_tokenId);
        
        WS_WRITE0(__warp_se_21, __warp_7_modelId);
        
        let (__warp_se_22) = WS0_INDEX_Uint256_to_Uint256(__warp_2_textureIds, __warp_9_tokenId);
        
        WS_WRITE0(__warp_se_22, __warp_8_textureId);
        
        Set_1d170fcf.emit(__warp_4_x, __warp_5_y, __warp_6_z, __warp_7_modelId, __warp_8_textureId, __warp_9_tokenId);
        
        
        
        return ();

    }


    func __warp_init_NFTCraft{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (){
    alloc_locals;


        
        WS_WRITE0(length, Uint256(low=200, high=0));
        
        
        
        return ();

    }


    func __warp_constructor_2{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, warp_memory : DictAccess*}(__warp_12__name : felt, __warp_13__symbol : felt)-> (){
    alloc_locals;


        
        wm_to_storage0(__warp_0_name, __warp_12__name);
        
        wm_to_storage0(__warp_1_symbol, __warp_13__symbol);
        
        
        
        return ();

    }


    func __warp_conditional_approve_095ea7b3_1{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_16_owner : felt)-> (__warp_rc_0 : felt, __warp_16_owner : felt){
    alloc_locals;


        
        let (__warp_se_41) = get_caller_address();
        
        let (__warp_se_42) = warp_eq(__warp_se_41, __warp_16_owner);
        
        if (__warp_se_42 != 0){
        
            
            let __warp_rc_0 = 1;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_16_owner = __warp_16_owner;
            
            
            
            return (__warp_rc_0, __warp_16_owner);
        }else{
        
            
            let (__warp_se_43) = WS5_INDEX_felt_to_warp_id(__warp_5_isApprovedForAll, __warp_16_owner);
            
            let (__warp_se_44) = WS0_READ_warp_id(__warp_se_43);
            
            let (__warp_se_45) = get_caller_address();
            
            let (__warp_se_46) = WS4_INDEX_felt_to_felt(__warp_se_44, __warp_se_45);
            
            let (__warp_se_47) = WS2_READ_felt(__warp_se_46);
            
            let __warp_rc_0 = __warp_se_47;
            
            let __warp_rc_0 = __warp_rc_0;
            
            let __warp_16_owner = __warp_16_owner;
            
            
            
            return (__warp_rc_0, __warp_16_owner);
        }

    }


    func __warp_conditional___warp_conditional_transferFrom_23b872dd_internal_3_5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19_from : felt)-> (__warp_rc_4 : felt, __warp_19_from : felt){
    alloc_locals;


        
        let (__warp_se_55) = get_caller_address();
        
        let (__warp_se_56) = warp_eq(__warp_se_55, __warp_19_from);
        
        if (__warp_se_56 != 0){
        
            
            let __warp_rc_4 = 1;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_19_from = __warp_19_from;
            
            
            
            return (__warp_rc_4, __warp_19_from);
        }else{
        
            
            let (__warp_se_57) = WS5_INDEX_felt_to_warp_id(__warp_5_isApprovedForAll, __warp_19_from);
            
            let (__warp_se_58) = WS0_READ_warp_id(__warp_se_57);
            
            let (__warp_se_59) = get_caller_address();
            
            let (__warp_se_60) = WS4_INDEX_felt_to_felt(__warp_se_58, __warp_se_59);
            
            let (__warp_se_61) = WS2_READ_felt(__warp_se_60);
            
            let __warp_rc_4 = __warp_se_61;
            
            let __warp_rc_4 = __warp_rc_4;
            
            let __warp_19_from = __warp_19_from;
            
            
            
            return (__warp_rc_4, __warp_19_from);
        }

    }


    func __warp_conditional_transferFrom_23b872dd_internal_3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_19_from : felt, __warp_21_id : Uint256)-> (__warp_rc_2 : felt, __warp_19_from : felt, __warp_21_id : Uint256){
    alloc_locals;


        
        let __warp_rc_4 = 0;
        
            
            let (__warp_tv_2, __warp_tv_3) = __warp_conditional___warp_conditional_transferFrom_23b872dd_internal_3_5(__warp_19_from);
            
            let __warp_19_from = __warp_tv_3;
            
            let __warp_rc_4 = __warp_tv_2;
        
        if (__warp_rc_4 != 0){
        
            
            let __warp_rc_2 = 1;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_19_from = __warp_19_from;
            
            let __warp_21_id = __warp_21_id;
            
            
            
            return (__warp_rc_2, __warp_19_from, __warp_21_id);
        }else{
        
            
            let (__warp_se_62) = get_caller_address();
            
            let (__warp_se_63) = WS2_INDEX_Uint256_to_felt(__warp_4_getApproved, __warp_21_id);
            
            let (__warp_se_64) = WS2_READ_felt(__warp_se_63);
            
            let (__warp_se_65) = warp_eq(__warp_se_62, __warp_se_64);
            
            let __warp_rc_2 = __warp_se_65;
            
            let __warp_rc_2 = __warp_rc_2;
            
            let __warp_19_from = __warp_19_from;
            
            let __warp_21_id = __warp_21_id;
            
            
            
            return (__warp_rc_2, __warp_19_from, __warp_21_id);
        }

    }


    func transferFrom_23b872dd_internal{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_19_from : felt, __warp_20_to : felt, __warp_21_id : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_66) = WS2_INDEX_Uint256_to_felt(__warp_2__ownerOf, __warp_21_id);
        
        let (__warp_se_67) = WS2_READ_felt(__warp_se_66);
        
        let (__warp_se_68) = warp_eq(__warp_19_from, __warp_se_67);
        
        with_attr error_message("WRONG_FROM"){
            assert __warp_se_68 = 1;
        }
        
        let (__warp_se_69) = warp_neq(__warp_20_to, 0);
        
        with_attr error_message("INVALID_RECIPIENT"){
            assert __warp_se_69 = 1;
        }
        
        let __warp_rc_2 = 0;
        
            
            let (__warp_tv_4, __warp_tv_5, __warp_tv_6) = __warp_conditional_transferFrom_23b872dd_internal_3(__warp_19_from, __warp_21_id);
            
            let __warp_21_id = __warp_tv_6;
            
            let __warp_19_from = __warp_tv_5;
            
            let __warp_rc_2 = __warp_tv_4;
        
        with_attr error_message("NOT_AUTHORIZED"){
            assert __warp_rc_2 = 1;
        }
        
            
            let __warp_cs_0 = __warp_19_from;
            
            let (__warp_se_70) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_0);
            
            let (__warp_se_71) = WS1_READ_Uint256(__warp_se_70);
            
            let (__warp_pse_1) = warp_sub_unsafe256(__warp_se_71, Uint256(low=1, high=0));
            
            let (__warp_se_72) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_0);
            
            WS_WRITE0(__warp_se_72, __warp_pse_1);
            
            warp_add_unsafe256(__warp_pse_1, Uint256(low=1, high=0));
            
            let __warp_cs_1 = __warp_20_to;
            
            let (__warp_se_73) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_1);
            
            let (__warp_se_74) = WS1_READ_Uint256(__warp_se_73);
            
            let (__warp_pse_2) = warp_add_unsafe256(__warp_se_74, Uint256(low=1, high=0));
            
            let (__warp_se_75) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_1);
            
            WS_WRITE0(__warp_se_75, __warp_pse_2);
            
            warp_sub_unsafe256(__warp_pse_2, Uint256(low=1, high=0));
        
        let (__warp_se_76) = WS2_INDEX_Uint256_to_felt(__warp_2__ownerOf, __warp_21_id);
        
        WS_WRITE1(__warp_se_76, __warp_20_to);
        
        let (__warp_se_77) = WS2_INDEX_Uint256_to_felt(__warp_4_getApproved, __warp_21_id);
        
        WS_WRITE1(__warp_se_77, 0);
        
        Transfer_ddf252ad.emit(__warp_19_from, __warp_20_to, __warp_21_id);
        
        
        
        return ();

    }


    func __warp_conditional___warp_conditional_supportsInterface_01ffc9a7_7_9(__warp_28_interfaceId : felt)-> (__warp_rc_8 : felt, __warp_28_interfaceId : felt){
    alloc_locals;


        
        let (__warp_se_78) = warp_eq(__warp_28_interfaceId, 33540519);
        
        if (__warp_se_78 != 0){
        
            
            let __warp_rc_8 = 1;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_28_interfaceId = __warp_28_interfaceId;
            
            
            
            return (__warp_rc_8, __warp_28_interfaceId);
        }else{
        
            
            let (__warp_se_79) = warp_eq(__warp_28_interfaceId, 2158778573);
            
            let __warp_rc_8 = __warp_se_79;
            
            let __warp_rc_8 = __warp_rc_8;
            
            let __warp_28_interfaceId = __warp_28_interfaceId;
            
            
            
            return (__warp_rc_8, __warp_28_interfaceId);
        }

    }


    func __warp_conditional_supportsInterface_01ffc9a7_7(__warp_28_interfaceId : felt)-> (__warp_rc_6 : felt, __warp_28_interfaceId : felt){
    alloc_locals;


        
        let __warp_rc_8 = 0;
        
            
            let (__warp_tv_7, __warp_tv_8) = __warp_conditional___warp_conditional_supportsInterface_01ffc9a7_7_9(__warp_28_interfaceId);
            
            let __warp_28_interfaceId = __warp_tv_8;
            
            let __warp_rc_8 = __warp_tv_7;
        
        if (__warp_rc_8 != 0){
        
            
            let __warp_rc_6 = 1;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_28_interfaceId = __warp_28_interfaceId;
            
            
            
            return (__warp_rc_6, __warp_28_interfaceId);
        }else{
        
            
            let (__warp_se_80) = warp_eq(__warp_28_interfaceId, 1532892063);
            
            let __warp_rc_6 = __warp_se_80;
            
            let __warp_rc_6 = __warp_rc_6;
            
            let __warp_28_interfaceId = __warp_28_interfaceId;
            
            
            
            return (__warp_rc_6, __warp_28_interfaceId);
        }

    }


    func _mint_4e6ec247{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_30_to : felt, __warp_31_id : Uint256)-> (){
    alloc_locals;


        
        let (__warp_se_81) = warp_neq(__warp_30_to, 0);
        
        with_attr error_message("INVALID_RECIPIENT"){
            assert __warp_se_81 = 1;
        }
        
        let (__warp_se_82) = WS2_INDEX_Uint256_to_felt(__warp_2__ownerOf, __warp_31_id);
        
        let (__warp_se_83) = WS2_READ_felt(__warp_se_82);
        
        let (__warp_se_84) = warp_eq(__warp_se_83, 0);
        
        with_attr error_message("ALREADY_MINTED"){
            assert __warp_se_84 = 1;
        }
        
            
            let __warp_cs_2 = __warp_30_to;
            
            let (__warp_se_85) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_2);
            
            let (__warp_se_86) = WS1_READ_Uint256(__warp_se_85);
            
            let (__warp_pse_3) = warp_add_unsafe256(__warp_se_86, Uint256(low=1, high=0));
            
            let (__warp_se_87) = WS3_INDEX_felt_to_Uint256(__warp_3__balanceOf, __warp_cs_2);
            
            WS_WRITE0(__warp_se_87, __warp_pse_3);
            
            warp_sub_unsafe256(__warp_pse_3, Uint256(low=1, high=0));
        
        let (__warp_se_88) = WS2_INDEX_Uint256_to_felt(__warp_2__ownerOf, __warp_31_id);
        
        WS_WRITE1(__warp_se_88, __warp_30_to);
        
        Transfer_ddf252ad.emit(0, __warp_30_to, __warp_31_id);
        
        
        
        return ();

    }

}


    @external
    func set_eccd65dc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_4_x : Uint256, __warp_5_y : Uint256, __warp_6_z : Uint256, __warp_7_modelId : Uint256, __warp_8_textureId : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_8_textureId);
        
        warp_external_input_check_int256(__warp_7_modelId);
        
        warp_external_input_check_int256(__warp_6_z);
        
        warp_external_input_check_int256(__warp_5_y);
        
        warp_external_input_check_int256(__warp_4_x);
        
        let (__warp_se_0) = warp_lt256(__warp_4_x, Uint256(low=200, high=0));
        
        with_attr error_message("NFTCraft: x length invalid"){
            assert __warp_se_0 = 1;
        }
        
        let (__warp_se_1) = warp_lt256(__warp_5_y, Uint256(low=200, high=0));
        
        with_attr error_message("NFTCraft: y length invalid"){
            assert __warp_se_1 = 1;
        }
        
        let (__warp_se_2) = warp_lt256(__warp_6_z, Uint256(low=200, high=0));
        
        with_attr error_message("NFTCraft: z length invalid"){
            assert __warp_se_2 = 1;
        }
        
        let (__warp_se_3) = WS1_READ_Uint256(NFTCraft.__warp_3_totalSupply);
        
        let (__warp_se_4) = warp_add256(__warp_se_3, Uint256(low=1, high=0));
        
        let (__warp_se_5) = WS_WRITE0(NFTCraft.__warp_3_totalSupply, __warp_se_4);
        
        let (__warp_9_tokenId) = warp_sub256(__warp_se_5, Uint256(low=1, high=0));
        
        let (__warp_se_6) = WS1_INDEX_Uint256_to_warp_id(NFTCraft.__warp_0_locations, __warp_4_x);
        
        let (__warp_se_7) = WS0_READ_warp_id(__warp_se_6);
        
        let (__warp_se_8) = WS1_INDEX_Uint256_to_warp_id(__warp_se_7, __warp_5_y);
        
        let (__warp_se_9) = WS0_READ_warp_id(__warp_se_8);
        
        let (__warp_se_10) = WS0_INDEX_Uint256_to_Uint256(__warp_se_9, __warp_6_z);
        
        let (__warp_se_11) = WS1_READ_Uint256(__warp_se_10);
        
        let (__warp_se_12) = warp_gt256(__warp_se_11, Uint256(low=0, high=0));
        
        if (__warp_se_12 != 0){
        
            
                
                let (__warp_se_13) = get_contract_address();
                
                let (__warp_se_14) = get_caller_address();
                
                NFTCraft.transferFrom_23b872dd_internal(__warp_se_13, __warp_se_14, __warp_9_tokenId);
            
            NFTCraft.set_eccd65dc_if_part1(__warp_9_tokenId, __warp_4_x, __warp_5_y, __warp_6_z, __warp_7_modelId, __warp_8_textureId);
            
            let __warp_uv0 = ();
            
            
            
            return ();
        }else{
        
            
            NFTCraft.set_eccd65dc_if_part1(__warp_9_tokenId, __warp_4_x, __warp_5_y, __warp_6_z, __warp_7_modelId, __warp_8_textureId);
            
            let __warp_uv1 = ();
            
            
            
            return ();
        }

    }


    @view
    func tokenURI_c87b56dd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(tokenId : Uint256)-> (__warp_10_len : felt, __warp_10 : felt*){
    alloc_locals;
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        warp_external_input_check_int256(tokenId);
        
        let (__warp_se_23) = WM0_d_arr();
        
        let (__warp_se_24) = wm_to_calldata0(__warp_se_23);
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return (__warp_se_24.len, __warp_se_24.ptr,);
    }
    }


    @view
    func locations_e27f67a3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_11__i0 : Uint256, __warp_12__i1 : Uint256, __warp_13__i2 : Uint256)-> (__warp_14 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_13__i2);
        
        warp_external_input_check_int256(__warp_12__i1);
        
        warp_external_input_check_int256(__warp_11__i0);
        
        let (__warp_se_25) = WS1_INDEX_Uint256_to_warp_id(NFTCraft.__warp_0_locations, __warp_11__i0);
        
        let (__warp_se_26) = WS0_READ_warp_id(__warp_se_25);
        
        let (__warp_se_27) = WS1_INDEX_Uint256_to_warp_id(__warp_se_26, __warp_12__i1);
        
        let (__warp_se_28) = WS0_READ_warp_id(__warp_se_27);
        
        let (__warp_se_29) = WS0_INDEX_Uint256_to_Uint256(__warp_se_28, __warp_13__i2);
        
        let (__warp_se_30) = WS1_READ_Uint256(__warp_se_29);
        
        
        
        return (__warp_se_30,);

    }


    @view
    func modelIds_19e2a109{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_15__i0 : Uint256)-> (__warp_16 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_15__i0);
        
        let (__warp_se_31) = WS0_INDEX_Uint256_to_Uint256(NFTCraft.__warp_1_modelIds, __warp_15__i0);
        
        let (__warp_se_32) = WS1_READ_Uint256(__warp_se_31);
        
        
        
        return (__warp_se_32,);

    }


    @view
    func textureIds_deebb7e9{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_17__i0 : Uint256)-> (__warp_18 : Uint256){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_17__i0);
        
        let (__warp_se_33) = WS0_INDEX_Uint256_to_Uint256(NFTCraft.__warp_2_textureIds, __warp_17__i0);
        
        let (__warp_se_34) = WS1_READ_Uint256(__warp_se_33);
        
        
        
        return (__warp_se_34,);

    }


    @view
    func length_1f7b6d32{syscall_ptr : felt*, range_check_ptr : felt}()-> (__warp_19 : Uint256){
    alloc_locals;


        
        
        
        return (Uint256(low=200, high=0),);

    }


    @view
    func totalSupply_18160ddd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_20 : Uint256){
    alloc_locals;


        
        let (__warp_se_35) = WS1_READ_Uint256(NFTCraft.__warp_3_totalSupply);
        
        
        
        return (__warp_se_35,);

    }


    @constructor
    func constructor{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(){
    alloc_locals;
    WARP_USED_STORAGE.write(13);
    WARP_NAMEGEN.write(9);
    let (local warp_memory : DictAccess*) = default_dict_new(0);
    local warp_memory_start: DictAccess* = warp_memory;
    dict_write{dict_ptr=warp_memory}(0,1);
    with warp_memory{

        
        let (__warp_constructor_parameter_0) = WM1_d_arr(78, 70, 84, 67, 114, 97, 102, 116);
        
        let (__warp_constructor_parameter_1) = WM2_d_arr(78, 70, 84, 67);
        
        NFTCraft.__warp_constructor_2(__warp_constructor_parameter_0, __warp_constructor_parameter_1);
        
        NFTCraft.__warp_init_NFTCraft();
        
        NFTCraft.__warp_constructor_3();
        
        default_dict_finalize(warp_memory_start, warp_memory, 0);
        
        
        return ();
    }
    }


    @view
    func ownerOf_6352211e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_8_id : Uint256)-> (__warp_9_owner : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_8_id);
        
        let __warp_9_owner = 0;
        
        let (__warp_se_36) = WS2_INDEX_Uint256_to_felt(NFTCraft.__warp_2__ownerOf, __warp_8_id);
        
        let (__warp_pse_0) = WS2_READ_felt(__warp_se_36);
        
        let __warp_9_owner = __warp_pse_0;
        
        let (__warp_se_37) = warp_neq(__warp_pse_0, 0);
        
        with_attr error_message("NOT_MINTED"){
            assert __warp_se_37 = 1;
        }
        
        
        
        return (__warp_9_owner,);

    }


    @view
    func balanceOf_70a08231{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_10_owner : felt)-> (__warp_11 : Uint256){
    alloc_locals;


        
        warp_external_input_check_address(__warp_10_owner);
        
        let (__warp_se_38) = warp_neq(__warp_10_owner, 0);
        
        with_attr error_message("ZERO_ADDRESS"){
            assert __warp_se_38 = 1;
        }
        
        let (__warp_se_39) = WS3_INDEX_felt_to_Uint256(NFTCraft.__warp_3__balanceOf, __warp_10_owner);
        
        let (__warp_se_40) = WS1_READ_Uint256(__warp_se_39);
        
        
        
        return (__warp_se_40,);

    }


    @external
    func approve_095ea7b3{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_14_spender : felt, __warp_15_id : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_15_id);
        
        warp_external_input_check_address(__warp_14_spender);
        
        let (__warp_se_48) = WS2_INDEX_Uint256_to_felt(NFTCraft.__warp_2__ownerOf, __warp_15_id);
        
        let (__warp_16_owner) = WS2_READ_felt(__warp_se_48);
        
        let __warp_rc_0 = 0;
        
            
            let (__warp_tv_0, __warp_tv_1) = NFTCraft.__warp_conditional_approve_095ea7b3_1(__warp_16_owner);
            
            let __warp_16_owner = __warp_tv_1;
            
            let __warp_rc_0 = __warp_tv_0;
        
        with_attr error_message("NOT_AUTHORIZED"){
            assert __warp_rc_0 = 1;
        }
        
        let (__warp_se_49) = WS2_INDEX_Uint256_to_felt(NFTCraft.__warp_4_getApproved, __warp_15_id);
        
        WS_WRITE1(__warp_se_49, __warp_14_spender);
        
        Approval_8c5be1e5.emit(__warp_16_owner, __warp_14_spender, __warp_15_id);
        
        
        
        return ();

    }


    @external
    func setApprovalForAll_a22cb465{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_17_operator : felt, __warp_18_approved : felt)-> (){
    alloc_locals;


        
        warp_external_input_check_bool(__warp_18_approved);
        
        warp_external_input_check_address(__warp_17_operator);
        
        let (__warp_se_50) = get_caller_address();
        
        let (__warp_se_51) = WS5_INDEX_felt_to_warp_id(NFTCraft.__warp_5_isApprovedForAll, __warp_se_50);
        
        let (__warp_se_52) = WS0_READ_warp_id(__warp_se_51);
        
        let (__warp_se_53) = WS4_INDEX_felt_to_felt(__warp_se_52, __warp_17_operator);
        
        WS_WRITE1(__warp_se_53, __warp_18_approved);
        
        let (__warp_se_54) = get_caller_address();
        
        ApprovalForAll_17307eab.emit(__warp_se_54, __warp_17_operator, __warp_18_approved);
        
        
        
        return ();

    }


    @external
    func safeTransferFrom_42842e0e{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_22_from : felt, __warp_23_to : felt, __warp_24_id : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_24_id);
        
        warp_external_input_check_address(__warp_23_to);
        
        warp_external_input_check_address(__warp_22_from);
        
        NFTCraft.transferFrom_23b872dd_internal(__warp_22_from, __warp_23_to, __warp_24_id);
        
        
        
        return ();

    }


    @external
    func safeTransferFrom_b88d4fde{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_25_from : felt, __warp_26_to : felt, __warp_27_id : Uint256, data_len : felt, data : felt*)-> (){
    alloc_locals;


        
        extern_input_check0(data_len, data);
        
        warp_external_input_check_int256(__warp_27_id);
        
        warp_external_input_check_address(__warp_26_to);
        
        warp_external_input_check_address(__warp_25_from);
        
        NFTCraft.transferFrom_23b872dd_internal(__warp_25_from, __warp_26_to, __warp_27_id);
        
        
        
        return ();

    }


    @view
    func supportsInterface_01ffc9a7{syscall_ptr : felt*, range_check_ptr : felt}(__warp_28_interfaceId : felt)-> (__warp_29 : felt){
    alloc_locals;


        
        warp_external_input_check_int32(__warp_28_interfaceId);
        
        let __warp_rc_6 = 0;
        
            
            let (__warp_tv_9, __warp_tv_10) = NFTCraft.__warp_conditional_supportsInterface_01ffc9a7_7(__warp_28_interfaceId);
            
            let __warp_28_interfaceId = __warp_tv_10;
            
            let __warp_rc_6 = __warp_tv_9;
        
        
        
        return (__warp_rc_6,);

    }


    @view
    func name_06fdde03{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_38_len : felt, __warp_38 : felt*){
    alloc_locals;


        
        let (__warp_se_89) = ws_dynamic_array_to_calldata0(NFTCraft.__warp_0_name);
        
        
        
        return (__warp_se_89.len, __warp_se_89.ptr,);

    }


    @view
    func symbol_95d89b41{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}()-> (__warp_39_len : felt, __warp_39 : felt*){
    alloc_locals;


        
        let (__warp_se_90) = ws_dynamic_array_to_calldata0(NFTCraft.__warp_1_symbol);
        
        
        
        return (__warp_se_90.len, __warp_se_90.ptr,);

    }


    @view
    func getApproved_081812fc{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_40__i0 : Uint256)-> (__warp_41 : felt){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_40__i0);
        
        let (__warp_se_91) = WS2_INDEX_Uint256_to_felt(NFTCraft.__warp_4_getApproved, __warp_40__i0);
        
        let (__warp_se_92) = WS2_READ_felt(__warp_se_91);
        
        
        
        return (__warp_se_92,);

    }


    @view
    func isApprovedForAll_e985e9c5{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(__warp_42__i0 : felt, __warp_43__i1 : felt)-> (__warp_44 : felt){
    alloc_locals;


        
        warp_external_input_check_address(__warp_43__i1);
        
        warp_external_input_check_address(__warp_42__i0);
        
        let (__warp_se_93) = WS5_INDEX_felt_to_warp_id(NFTCraft.__warp_5_isApprovedForAll, __warp_42__i0);
        
        let (__warp_se_94) = WS0_READ_warp_id(__warp_se_93);
        
        let (__warp_se_95) = WS4_INDEX_felt_to_felt(__warp_se_94, __warp_43__i1);
        
        let (__warp_se_96) = WS2_READ_felt(__warp_se_95);
        
        
        
        return (__warp_se_96,);

    }


    @external
    func transferFrom_23b872dd{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt, bitwise_ptr : BitwiseBuiltin*}(__warp_19_from : felt, __warp_20_to : felt, __warp_21_id : Uint256)-> (){
    alloc_locals;


        
        warp_external_input_check_int256(__warp_21_id);
        
        warp_external_input_check_address(__warp_20_to);
        
        warp_external_input_check_address(__warp_19_from);
        
        NFTCraft.transferFrom_23b872dd_internal(__warp_19_from, __warp_20_to, __warp_21_id);
        
        let __warp_uv2 = ();
        
        
        
        return ();

    }

@storage_var
func WARP_STORAGE(index: felt) -> (val: felt){
}
@storage_var
func WARP_USED_STORAGE() -> (val: felt){
}
@storage_var
func WARP_NAMEGEN() -> (name: felt){
}
func readId{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr : felt}(loc: felt) -> (val: felt){
    alloc_locals;
    let (id) = WARP_STORAGE.read(loc);
    if (id == 0){
        let (id) = WARP_NAMEGEN.read();
        WARP_NAMEGEN.write(id + 1);
        WARP_STORAGE.write(loc, id + 1);
        return (id + 1,);
    }else{
        return (id,);
    }
}