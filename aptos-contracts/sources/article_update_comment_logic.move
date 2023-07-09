module aptos_blog_example::article_update_comment_logic {
    use aptos_blog_example::article;
    use aptos_blog_example::comment;
    use aptos_blog_example::comment_updated;
    use std::string::String;

    friend aptos_blog_example::article_aggregate;

    public(friend) fun verify(
        account: &signer,
        comment_seq_id: u64,
        commenter: String,
        body: String,
        owner: address,
        article: &article::Article,
    ): article::CommentUpdated {
        let _ = account;
        article::new_comment_updated(
            article,
            comment_seq_id,
            commenter,
            body,
            owner,
        )
    }

    public(friend) fun mutate(
        comment_updated: &article::CommentUpdated,
        article: article::Article,
    ): article::Article {
        let comment_seq_id = comment_updated::comment_seq_id(comment_updated);
        let commenter = comment_updated::commenter(comment_updated);
        let body = comment_updated::body(comment_updated);
        let owner = comment_updated::owner(comment_updated);
        let article_id = article::article_id(&article);
        let _ = article_id;
        let comment = article::borrow_mut_comment(&mut article, comment_seq_id);
        comment::set_commenter(comment, commenter);
        comment::set_body(comment, body);
        comment::set_owner(comment, owner);
        article
    }

}