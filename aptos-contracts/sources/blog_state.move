// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module aptos_blog_demo::blog_state {
    use aptos_blog_demo::genesis_account;
    use aptos_blog_demo::pass_object;
    use aptos_framework::account;
    use aptos_framework::event;
    friend aptos_blog_demo::blog_state_create_logic;
    friend aptos_blog_demo::blog_state_update_logic;
    friend aptos_blog_demo::blog_state_delete_logic;
    friend aptos_blog_demo::blog_state_aggregate;

    const EDATA_TOO_LONG: u64 = 102;
    const EINAPPROPRIATE_VERSION: u64 = 103;
    const ENOT_INITIALIZED: u64 = 110;

    struct Events has key {
        blog_state_created_handle: event::EventHandle<BlogStateCreated>,
        blog_state_updated_handle: event::EventHandle<BlogStateUpdated>,
        blog_state_deleted_handle: event::EventHandle<BlogStateDeleted>,
    }

    public fun initialize(account: &signer) {
        genesis_account::assert_genesis_account(account);

        let res_account = genesis_account::resource_account_signer();
        move_to(&res_account, Events {
            blog_state_created_handle: account::new_event_handle<BlogStateCreated>(&res_account),
            blog_state_updated_handle: account::new_event_handle<BlogStateUpdated>(&res_account),
            blog_state_deleted_handle: account::new_event_handle<BlogStateDeleted>(&res_account),
        });

    }

    struct BlogState has key, store {
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

    struct BlogStateCreated has store, drop {
        is_emergency: bool,
    }

    public fun blog_state_created_is_emergency(blog_state_created: &BlogStateCreated): bool {
        blog_state_created.is_emergency
    }

    public(friend) fun new_blog_state_created(
        is_emergency: bool,
    ): BlogStateCreated {
        BlogStateCreated {
            is_emergency,
        }
    }

    struct BlogStateUpdated has store, drop {
        version: u64,
        is_emergency: bool,
    }

    public fun blog_state_updated_is_emergency(blog_state_updated: &BlogStateUpdated): bool {
        blog_state_updated.is_emergency
    }

    public(friend) fun new_blog_state_updated(
        blog_state: &BlogState,
        is_emergency: bool,
    ): BlogStateUpdated {
        BlogStateUpdated {
            version: version(blog_state),
            is_emergency,
        }
    }

    struct BlogStateDeleted has store, drop {
        version: u64,
    }

    public(friend) fun new_blog_state_deleted(
        blog_state: &BlogState,
    ): BlogStateDeleted {
        BlogStateDeleted {
            version: version(blog_state),
        }
    }


    public(friend) fun update_version_and_add(blog_state: BlogState) {
        blog_state.version = blog_state.version + 1;
        //assert!(blog_state.version != 0, EINAPPROPRIATE_VERSION);
        private_add_blog_state(blog_state);
    }

    public(friend) fun add_blog_state(blog_state: BlogState) {
        assert!(blog_state.version == 0, EINAPPROPRIATE_VERSION);
        private_add_blog_state(blog_state);
    }

    public(friend) fun remove_blog_state(): BlogState acquires BlogState {
        assert!(exists<BlogState>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        move_from<BlogState>(genesis_account::resouce_account_address())
    }

    fun private_add_blog_state(blog_state: BlogState) {
        move_to(&genesis_account::resource_account_signer(), blog_state);
    }

    public fun get_blog_state(): pass_object::PassObject<BlogState> acquires BlogState {
        let blog_state = remove_blog_state();
        pass_object::new(blog_state)
    }

    public fun return_blog_state(blog_state_pass_obj: pass_object::PassObject<BlogState>) {
        let blog_state = pass_object::extract(blog_state_pass_obj);
        private_add_blog_state(blog_state);
    }

    public(friend) fun drop_blog_state(blog_state: BlogState) {
        let BlogState {
            version: _version,
            is_emergency: _is_emergency,
        } = blog_state;
    }

    public(friend) fun emit_blog_state_created(blog_state_created: BlogStateCreated) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_state_created_handle, blog_state_created);
    }

    public(friend) fun emit_blog_state_updated(blog_state_updated: BlogStateUpdated) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_state_updated_handle, blog_state_updated);
    }

    public(friend) fun emit_blog_state_deleted(blog_state_deleted: BlogStateDeleted) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_state_deleted_handle, blog_state_deleted);
    }

}
