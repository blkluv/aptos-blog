module aptos_blog_example::article_remove_comment_logic {
    use aptos_blog_example::article;
    use aptos_blog_example::comment_removed;

    friend aptos_blog_example::article_aggregate;

    public(friend) fun verify(
        account: &signer,
        comment_seq_id: u64,
        article: &article::Article,
    ): article::CommentRemoved {
        let _ = account;
        article::new_comment_removed(
            article,
            comment_seq_id,
        )
    }

    public(friend) fun mutate(
        comment_removed: &article::CommentRemoved,
        article: article::Article,
    ): article::Article {
        let comment_seq_id = comment_removed::comment_seq_id(comment_removed);
        let article_id = article::article_id(&article);
        let _ = article_id;
        article::remove_comment(&mut article, comment_seq_id);
        article
    }

}
