/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.kafka.utils;

import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.transactions.TransactionLocalContext;
import io.ballerina.runtime.transactions.TransactionResourceManager;
import io.ballerina.stdlib.kafka.impl.KafkaTransactionContext;
import org.apache.kafka.clients.producer.KafkaProducer;

import java.util.Objects;

import static io.ballerina.stdlib.kafka.utils.KafkaConstants.CONNECTOR_ID;
import static io.ballerina.stdlib.kafka.utils.KafkaConstants.NATIVE_PRODUCER;
import static io.ballerina.stdlib.kafka.utils.KafkaConstants.TRANSACTION_CONTEXT;

/**
 * Utility functions for ballerina kafka transactions.
 */
public class TransactionUtils {

    private TransactionUtils() {
    }

    public static void handleTransactions(BObject producer) {
        KafkaTransactionContext transactionContext = (KafkaTransactionContext) producer
                .getNativeData(TRANSACTION_CONTEXT);
        if (Objects.nonNull(transactionContext)) {
            String connectorId = producer.getStringValue(CONNECTOR_ID).getValue();
            TransactionResourceManager trxResourceManager = TransactionResourceManager.getInstance();
            if (Objects.isNull(trxResourceManager.getCurrentTransactionContext().getTransactionContext(connectorId))) {
                transactionContext.beginTransaction();
                registerKafkaTransactionContext(trxResourceManager, transactionContext, connectorId);
            }
        }
        // Do nothing if this is non-transactional producer.
    }

    public static KafkaTransactionContext createKafkaTransactionContext(BObject producer) {
        KafkaProducer kafkaProducer = (KafkaProducer) producer.getNativeData(NATIVE_PRODUCER);
        return new KafkaTransactionContext(kafkaProducer);
    }

    public static void registerKafkaTransactionContext(TransactionResourceManager trxResourceManager,
                                                       KafkaTransactionContext transactionContext, String connectorId) {
        TransactionLocalContext transactionLocalContext = trxResourceManager.getCurrentTransactionContext();
        transactionLocalContext.registerTransactionContext(connectorId, transactionContext);
    }
}
