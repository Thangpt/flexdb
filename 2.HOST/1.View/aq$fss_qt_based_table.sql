CREATE OR REPLACE FORCE VIEW AQ$FSS_QT_BASED_TABLE AS
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(s.subscriber_type,2,'UNDELIVERABLE',
                                             decode(h.dequeue_time, NULL,decode(l.dequeue_time, NULL, decode(state, 0,   'READY',	     
                              		                                          1,   'WAIT',	     
                                                                                  2,   'PROCESSED',	     
                                                                                  3,   'EXPIRED',
                                                                                  8,   'DEFERRED',
                                                                                 10,  'BUFFERED_EXPIRED'),(decode(l.transaction_id, NULL, 'UNDELIVERABLE', 'PROCESSED'))), (decode(h.transaction_id, NULL, 'UNDELIVERABLE', 'PROCESSED')))
                          )                         MSG_STATE,  cast(FROM_TZ(qt.delay, '00:00')
                 at time zone sessiontimezone as date) delay,  cast(FROM_TZ(qt.delay, '00:00')
                 at time zone sessiontimezone as timestamp) DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '00:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '00:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  qt.enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, 
                 decode(l.transaction_id, NULL, TO_DATE(NULL), l.dequeue_time),
                        cast(FROM_TZ(h.dequeue_time, '00:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, 
            decode(l.transaction_id, NULL, TO_TIMESTAMP(NULL), l.dequeue_time),
                        cast(FROM_TZ(h.dequeue_time, '00:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  decode(h.dequeue_user, NULL, l.dequeue_user, h.dequeue_user) 
	         DEQ_USER_ID,  decode(h.transaction_id, NULL, l.transaction_id, 
                 h.transaction_id) DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, decode (l.dequeue_time, NULL,
                   decode (state, 3, exception_queue, NULL), 
                   decode (l.transaction_id, NULL, NULL, exception_queue)),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, decode (l.dequeue_time, NULL,
                   decode (state, 3, exception_qschema, NULL), 
                   decode (l.transaction_id, NULL, NULL, exception_qschema)),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(s.subscriber_type,2,
                                         'Messages to be cleaned up later',
                        decode(h.dequeue_time, NULL, 
                               decode(state, 3, 
                                           decode(h.transaction_id, NULL, 
                                           decode (expiration , NULL , 
                                                   'MAX_RETRY_EXCEEDED',
                                                   'TIME_EXPIRATION'),
                                                   'INVALID_TRANSACTION', NULL,
                                                   'MAX_RETRY_EXCEEDED'), NULL),
                                           decode(h.transaction_id, NULL, 
                                                 'PROPAGATION_FAILURE', NULL)))
                 EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "FSS_QT_BASED_TABLE" qt, "AQ$_FSS_QT_BASED_TABLE_H" h LEFT OUTER JOIN "AQ$_FSS_QT_BASED_TABLE_L" l  ON h.msgid = l.msgid AND h.subscriber# = l.subscriber# AND h.name = l.name AND h.address# = l.address#, "AQ$_FSS_QT_BASED_TABLE_S" s  WHERE  qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND (qt.state != 7 OR   qt.state != 9 )     WITH READ ONLY;

