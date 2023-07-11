// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module aptos_blog_demo::blog_state {
    use aptos_blog_demo::genesis_account;

    const EID_DATA_TOO_LONG: u64 = 102;
    const EINAPPROPRIATE_VERSION: u64 = 103;
    const ENOT_INITIALIZED: u64 = 110;

    struct Events has key {}

    public fun initialize(account: &signer) {
        genesis_account::assert_genesis_account(account);

        let res_account = genesis_account::resource_account_signer();
        move_to(&res_account, Events {});
    }

    struct BlogState has key {
        version: u64,
        is_emergency: bool,
    }

    public fun version(blog_state: &BlogState): u64 {
        blog_state.version
    }

    public fun is_emergency(blog_state: &BlogState): bool {
        blog_state.is_emergency
    }

    public(friend) fun set_is_emergency(blog_state: &mut BlogState, is_emergency: bool) {
        blog_state.is_emergency = is_emergency;
    }

    public(friend) fun new_blog_state(
        is_emergency: bool,
    ): BlogState {
        BlogState {
            version: 0,
            is_emergency,
        }
    }
}
