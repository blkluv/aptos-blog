// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.aptosblogdemo.aptos.contract.repository;

import org.test.aptosblogdemo.domain.article.*;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.*;

public interface ArticleEventRepository extends JpaRepository<AbstractArticleEvent, ArticleEventId> {

    List<AbstractArticleEvent> findByStatusIsNull();

    AbstractArticleEvent.ArticleCreated findFirstArticleCreatedByOrderByAptosEventSequenceNumber();

    AbstractArticleEvent.ArticleUpdated findFirstArticleUpdatedByOrderByAptosEventSequenceNumber();

    AbstractArticleEvent.ArticleDeleted findFirstArticleDeletedByOrderByAptosEventSequenceNumber();

    AbstractArticleEvent.CommentAdded findFirstCommentAddedByOrderByAptosEventSequenceNumber();

    AbstractArticleEvent.CommentRemoved findFirstCommentRemovedByOrderByAptosEventSequenceNumber();

    AbstractArticleEvent.CommentUpdated findFirstCommentUpdatedByOrderByAptosEventSequenceNumber();

}