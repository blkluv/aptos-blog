// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

module aptos_blog_demo::blog {
    use aptos_blog_demo::genesis_account;
    use aptos_blog_demo::pass_object;
    use aptos_framework::account;
    use aptos_framework::event;
    use std::string::String;
    friend aptos_blog_demo::blog_create_logic;
    friend aptos_blog_demo::blog_add_article_logic;
    friend aptos_blog_demo::blog_remove_article_logic;
    friend aptos_blog_demo::blog_update_logic;
    friend aptos_blog_demo::blog_delete_logic;
    friend aptos_blog_demo::blog_aggregate;

    const EDATA_TOO_LONG: u64 = 102;
    const EINAPPROPRIATE_VERSION: u64 = 103;
    const ENOT_INITIALIZED: u64 = 110;

    struct Events has key {
        blog_created_handle: event::EventHandle<BlogCreated>,
        article_added_to_blog_handle: event::EventHandle<ArticleAddedToBlog>,
        article_removed_from_blog_handle: event::EventHandle<ArticleRemovedFromBlog>,
        blog_updated_handle: event::EventHandle<BlogUpdated>,
        blog_deleted_handle: event::EventHandle<BlogDeleted>,
    }

    public fun initialize(account: &signer) {
        genesis_account::assert_genesis_account(account);

        let res_account = genesis_account::resource_account_signer();
        move_to(&res_account, Events {
            blog_created_handle: account::new_event_handle<BlogCreated>(&res_account),
            article_added_to_blog_handle: account::new_event_handle<ArticleAddedToBlog>(&res_account),
            article_removed_from_blog_handle: account::new_event_handle<ArticleRemovedFromBlog>(&res_account),
            blog_updated_handle: account::new_event_handle<BlogUpdated>(&res_account),
            blog_deleted_handle: account::new_event_handle<BlogDeleted>(&res_account),
        });

    }

    struct Blog has key, store {
        version: u64,
        name: String,
        articles: vector<u128>,
        is_emergency: bool,
    }

    public fun version(blog: &Blog): u64 {
        blog.version
    }

    public fun name(blog: &Blog): String {
        blog.name
    }

    public(friend) fun set_name(blog: &mut Blog, name: String) {
        assert!(std::string::length(&name) <= 200, EDATA_TOO_LONG);
        blog.name = name;
    }

    public fun articles(blog: &Blog): vector<u128> {
        blog.articles
    }

    public(friend) fun set_articles(blog: &mut Blog, articles: vector<u128>) {
        blog.articles = articles;
    }

    public fun is_emergency(blog: &Blog): bool {
        blog.is_emergency
    }

    public(friend) fun set_is_emergency(blog: &mut Blog, is_emergency: bool) {
        blog.is_emergency = is_emergency;
    }

    public(friend) fun new_blog(
        name: String,
        articles: vector<u128>,
        is_emergency: bool,
    ): Blog {
        assert!(std::string::length(&name) <= 200, EDATA_TOO_LONG);
        Blog {
            version: 0,
            name,
            articles,
            is_emergency,
        }
    }

    struct BlogCreated has store, drop {
        name: String,
        is_emergency: bool,
    }

    public fun blog_created_name(blog_created: &BlogCreated): String {
        blog_created.name
    }

    public fun blog_created_is_emergency(blog_created: &BlogCreated): bool {
        blog_created.is_emergency
    }

    public(friend) fun new_blog_created(
        name: String,
        is_emergency: bool,
    ): BlogCreated {
        BlogCreated {
            name,
            is_emergency,
        }
    }

    struct ArticleAddedToBlog has store, drop {
        version: u64,
        article_id: u128,
    }

    public fun article_added_to_blog_article_id(article_added_to_blog: &ArticleAddedToBlog): u128 {
        article_added_to_blog.article_id
    }

    public(friend) fun new_article_added_to_blog(
        blog: &Blog,
        article_id: u128,
    ): ArticleAddedToBlog {
        ArticleAddedToBlog {
            version: version(blog),
            article_id,
        }
    }

    struct ArticleRemovedFromBlog has store, drop {
        version: u64,
        article_id: u128,
    }

    public fun article_removed_from_blog_article_id(article_removed_from_blog: &ArticleRemovedFromBlog): u128 {
        article_removed_from_blog.article_id
    }

    public(friend) fun new_article_removed_from_blog(
        blog: &Blog,
        article_id: u128,
    ): ArticleRemovedFromBlog {
        ArticleRemovedFromBlog {
            version: version(blog),
            article_id,
        }
    }

    struct BlogUpdated has store, drop {
        version: u64,
        name: String,
        articles: vector<u128>,
        is_emergency: bool,
    }

    public fun blog_updated_name(blog_updated: &BlogUpdated): String {
        blog_updated.name
    }

    public fun blog_updated_articles(blog_updated: &BlogUpdated): vector<u128> {
        blog_updated.articles
    }

    public fun blog_updated_is_emergency(blog_updated: &BlogUpdated): bool {
        blog_updated.is_emergency
    }

    public(friend) fun new_blog_updated(
        blog: &Blog,
        name: String,
        articles: vector<u128>,
        is_emergency: bool,
    ): BlogUpdated {
        BlogUpdated {
            version: version(blog),
            name,
            articles,
            is_emergency,
        }
    }

    struct BlogDeleted has store, drop {
        version: u64,
    }

    public(friend) fun new_blog_deleted(
        blog: &Blog,
    ): BlogDeleted {
        BlogDeleted {
            version: version(blog),
        }
    }


    public(friend) fun update_version_and_add(blog: Blog) {
        blog.version = blog.version + 1;
        //assert!(blog.version != 0, EINAPPROPRIATE_VERSION);
        private_add_blog(blog);
    }

    public(friend) fun add_blog(blog: Blog) {
        assert!(blog.version == 0, EINAPPROPRIATE_VERSION);
        private_add_blog(blog);
    }

    public(friend) fun remove_blog(): Blog acquires Blog {
        assert!(exists<Blog>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        move_from<Blog>(genesis_account::resouce_account_address())
    }

    fun private_add_blog(blog: Blog) {
        move_to(&genesis_account::resource_account_signer(), blog);
    }

    public fun get_blog(): pass_object::PassObject<Blog> acquires Blog {
        let blog = remove_blog();
        pass_object::new(blog)
    }

    public fun singleton_name(): String acquires Blog {
        let blog = borrow_global<Blog>(genesis_account::resouce_account_address());
        blog.name
    }

    public fun singleton_articles(): vector<u128> acquires Blog {
        let blog = borrow_global<Blog>(genesis_account::resouce_account_address());
        blog.articles
    }

    public fun singleton_is_emergency(): bool acquires Blog {
        let blog = borrow_global<Blog>(genesis_account::resouce_account_address());
        blog.is_emergency
    }

    public fun return_blog(blog_pass_obj: pass_object::PassObject<Blog>) {
        let blog = pass_object::extract(blog_pass_obj);
        private_add_blog(blog);
    }

    public(friend) fun drop_blog(blog: Blog) {
        let Blog {
            version: _version,
            name: _name,
            articles: _articles,
            is_emergency: _is_emergency,
        } = blog;
    }

    public(friend) fun emit_blog_created(blog_created: BlogCreated) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_created_handle, blog_created);
    }

    public(friend) fun emit_article_added_to_blog(article_added_to_blog: ArticleAddedToBlog) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.article_added_to_blog_handle, article_added_to_blog);
    }

    public(friend) fun emit_article_removed_from_blog(article_removed_from_blog: ArticleRemovedFromBlog) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.article_removed_from_blog_handle, article_removed_from_blog);
    }

    public(friend) fun emit_blog_updated(blog_updated: BlogUpdated) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_updated_handle, blog_updated);
    }

    public(friend) fun emit_blog_deleted(blog_deleted: BlogDeleted) acquires Events {
        assert!(exists<Events>(genesis_account::resouce_account_address()), ENOT_INITIALIZED);
        let events = borrow_global_mut<Events>(genesis_account::resouce_account_address());
        event::emit_event(&mut events.blog_deleted_handle, blog_deleted);
    }

}