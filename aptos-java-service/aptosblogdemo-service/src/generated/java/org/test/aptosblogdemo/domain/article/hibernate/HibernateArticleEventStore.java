// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.aptosblogdemo.domain.article.hibernate;

import java.io.Serializable;
import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.aptosblogdemo.domain.*;
import org.test.aptosblogdemo.specialization.*;
import org.test.aptosblogdemo.specialization.hibernate.AbstractHibernateEventStore;
import org.hibernate.*;
import org.hibernate.criterion.*;
import org.springframework.transaction.annotation.Transactional;
import org.test.aptosblogdemo.domain.article.*;

public class HibernateArticleEventStore extends AbstractHibernateEventStore {
    @Override
    protected Serializable getEventId(EventStoreAggregateId eventStoreAggregateId, long version)
    {
        return new ArticleEventId((BigInteger) eventStoreAggregateId.getId(), BigInteger.valueOf(version));
    }

    @Override
    protected Class getSupportedEventType()
    {
        return AbstractArticleEvent.class;
    }

    @Transactional(readOnly = true)
    @Override
    public EventStream loadEventStream(Class eventType, EventStoreAggregateId eventStoreAggregateId, long version) {
        Class supportedEventType = AbstractArticleEvent.class;
        if (!eventType.isAssignableFrom(supportedEventType)) {
            throw new UnsupportedOperationException();
        }
        BigInteger idObj = (BigInteger) eventStoreAggregateId.getId();
        Criteria criteria = getCurrentSession().createCriteria(AbstractArticleEvent.class);
        criteria.add(Restrictions.eq("articleEventId.articleId", idObj));
        criteria.add(Restrictions.le("articleEventId.offChainVersion", version));
        criteria.addOrder(Order.asc("articleEventId.offChainVersion"));
        List es = criteria.list();
        for (Object e : es) {
            ((AbstractArticleEvent) e).setEventReadOnly(true);
        }
        EventStream eventStream = new EventStream();
        if (es.size() > 0) {
            eventStream.setSteamVersion(((AbstractArticleEvent) es.get(es.size() - 1)).getArticleEventId().getVersion().longValue());
        } else {
            //todo?
        }
        eventStream.setEvents(es);
        return eventStream;
    }

}
