// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.aptosblogdemo.domain.article;

import java.util.*;
import java.util.Date;
import java.math.BigInteger;
import org.test.aptosblogdemo.domain.*;
import org.test.aptosblogdemo.specialization.Event;

public interface CommentEvent extends Event {

    interface SqlCommentEvent extends CommentEvent {
        CommentEventId getCommentEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    BigInteger getCommentSeqId();

    //void setCommentSeqId(BigInteger commentSeqId);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}
