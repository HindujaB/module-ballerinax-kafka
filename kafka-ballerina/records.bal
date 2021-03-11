// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Common record types
# Represents the topic partition position in which the consumed record is stored.
#
# + partition - The `kafka:TopicPartition` to which the record is related
# + offset - Offset in which the record is stored in the partition
public type PartitionOffset record {|
    TopicPartition partition;
    int offset;
|};

# Represents a topic partition.
#
# + topic - Topic to which the partition is related
# + partition - Index for the partition
public type TopicPartition record {|
    string topic;
    int partition;
|};

// Security-related records
# Configurations for facilitating secure communication with the Kafka server.
#
# + keyStore - Configurations associated with the KeyStore
# + trustStore - Configurations associated with the TrustStore
# + protocol - Configurations related to the SSL/TLS protocol and the version to be used
# + sslProvider - The name of the security provider used for SSL connections. Default value is the default security
#                 provider of the JVM
# + sslKeyPassword - The password of the private key in the key store file. This is optional for the client
# + sslCipherSuites - A list of Cipher suites. This is a named combination of the authentication, encryption, MAC, and key
#                     exchange algorithms used to negotiate the security settings for a network connection using the TLS
#                     or SSL network protocols. By default, all the available Cipher suites are supported
# + sslEndpointIdentificationAlgorithm - The endpoint identification algorithm to validate the server hostname using
#                                        the server certificate
# + sslSecureRandomImplementation - The `SecureRandom` PRNG implementation to use for the SSL cryptography operations
public type SecureSocket record {|
    KeyStore keyStore;
    TrustStore trustStore;
    Protocols protocol;
    string sslProvider?;
    string sslKeyPassword?;
    string sslCipherSuites?;
    string sslEndpointIdentificationAlgorithm?;
    string sslSecureRandomImplementation?;
|};

# Configurations related to the KeyStore.
#
# + keyStoreType - The file format of the KeyStore file. This is optional for the client
# + location - The location of the KeyStore file. This is optional for the client and can be used for two-way
#              authentication for the client
# + password - The store password for the KeyStore file. This is optional for the client and is only needed if
#              the `ssl.keystore.location` is configured
# + keyManagerAlgorithm - The algorithm used by the key manager factory for SSL connections. The default value is the
#                         key manager factory algorithm configured for the JVM
public type KeyStore record {|
    string keyStoreType?;
    string location;
    string password;
    string keyManagerAlgorithm?;
|};

# Configurations related to the TrustStore.
#
# + trustStoreType - The file format of the TrustStore file
# + location - The location of the TrustStore file
# + password - The password for the TrustStore file. If a password is not set, access to the TrustStore is still
#              available but integrity checking is disabled
# + trustManagerAlgorithm - The algorithm used by the trust manager factory for SSL connections. The default value is
#                           the trust manager factory algorithm configured for the JVM
public type TrustStore record {|
    string trustStoreType?;
    string location;
    string password;
    string trustManagerAlgorithm?;
|};

# Configurations related to the SSL/TLS protocol and the versions to be used.
#
# + sslProtocol - The SSL protocol used to generate the SSLContext. The default setting is TLS, which is fine for most
#                 cases. Allowed values in recent JVMs are TLS, TLSv1.1, and TLSv1.2. Also, SSL, SSLv2 and SSLv3 may be
#                 supported in older JVMs but their usage is discouraged due to known security vulnerabilities
# + sslProtocolVersions - The list of protocols enabled for SSL connections
public type Protocols record {|
    string sslProtocol;
    string sslProtocolVersions;
|};

# Configurations related to Kafka authentication mechanisms.
#
# + mechanism - Type of the authentication mechanism. Currently, SASL_PLAIN and SCRAM are supported. See
#               `kafka:AuthenticationMechanism` for more information
# + username - The username to use to authenticate the Kafka producer/consumer
# + password - The password to use to authenticate the Kafka producer/consumer
public type AuthenticationConfiguration record {|
    AuthenticationMechanism mechanism = AUTH_SASL_PLAIN;
    string username;
    string password;
|};

// Consumer-related records
# Configurations related to consumer endpoint.
#
# + bootstrapServers - List of remote server endpoints of kafka brokers
# + groupId - Unique string that identifies the consumer
# + topics - Topics to be subscribed by the consumer
# + offsetReset - Offset reset strategy if no initial offset
# + partitionAssignmentStrategy - Strategy class for handling the partition assignment among consumers
# + metricsRecordingLevel - Metrics recording level
# + metricsReporterClasses - Metrics reporter classes
# + clientId - Identifier to be used for server side logging
# + interceptorClasses - Interceptor classes to be used before sending records
# + isolationLevel - Transactional message reading method
# + schemaRegistryUrl - Avro schema registry url. Use this field to specify schema registry url, if Avro serializer
#                       is used
# + additionalProperties - Additional properties for the property fields not provided by Ballerina Kafka module. Use
#                          this with caution since this can override any of the fields. It is not recomendded to use
#                          this field except in an extreme situation
# + sessionTimeout - Timeout used to detect consumer failures when heartbeat threshold is reached in seconds
# + heartBeatInterval - Expected time between heartbeats in seconds
# + metadataMaxAge - Maximum time to force a refresh of metadata in seconds
# + autoCommitInterval - Auto committing interval (in seconds) for commit offset, when auto-commit is enabled
# + maxPartitionFetchBytes - The maximum amount of data per-partition the server returns
# + sendBuffer - Size of the TCP send buffer (SO_SNDBUF)
# + receiveBuffer - Size of the TCP receive buffer (SO_RCVBUF)
# + fetchMinBytes - Minimum amount of data the server should return for a fetch request
# + fetchMaxBytes - Maximum amount of data the server should return for a fetch request
# + fetchMaxWaitTime - Maximum amount of time (in seconds) the server will block before answering the fetch request
# + reconnectBackoffTimeMax - Maximum amount of time in seconds to wait when reconnecting
# + retryBackoff - Time (in seconds) to wait before attempting to retry a failed request
# + metricsSampleWindow - Window of time (in seconds) a metrics sample is computed over
# + metricsNumSamples - Number of samples maintained to compute metrics
# + requestTimeout - Wait time (in seconds) for response of a request
# + connectionMaxIdleTime - Close idle connections after the number of seconds
# + maxPollRecords - Maximum number of records returned in a single call to poll
# + maxPollInterval - Maximum delay between invocations of poll
# + reconnectBackoffTime - Time (in seconds) to wait before attempting to reconnect
# + pollingTimeout - Timeout interval for polling in seconds
# + pollingInterval - Polling interval for the consumer in seconds
# + concurrentConsumers - Number of concurrent consumers
# + defaultApiTimeout - Default API timeout value (in seconds) for APIs with duration
# + autoCommit - Enables auto committing offsets
# + checkCRCS - Check the CRC32 of the records consumed. This ensures that no on-the-wire or on-disk corruption to
#               the messages occurred. This may add some overhead, and might needed set to `false` if extreme
#               performance is required
# + excludeInternalTopics - Whether records from internal topics should be exposed to the consumer
# + decoupleProcessing - Decouples processing
# + secureSocket - Configurations related to SSL/TLS encryption
# + authenticationConfiguration - Authentication-related configurations for the Kafka consumer
# + securityProtocol - Type of the security protocol to use in the broker connection
public type ConsumerConfiguration record {|
    string bootstrapServers;
    string groupId?;
    string[] topics?;
    OffsetResetMethod offsetReset?;
    string partitionAssignmentStrategy?;
    string metricsRecordingLevel?;
    string metricsReporterClasses?;
    string clientId?;
    string interceptorClasses?;
    IsolationLevel isolationLevel?;

    string schemaRegistryUrl?;

    map<string> additionalProperties?;

    decimal sessionTimeout?;
    decimal heartBeatInterval?;
    decimal metadataMaxAge?;
    decimal autoCommitInterval?;
    int maxPartitionFetchBytes?;
    int sendBuffer?;
    int receiveBuffer?;
    int fetchMinBytes?;
    int fetchMaxBytes?;
    decimal fetchMaxWaitTime?;
    decimal reconnectBackoffTimeMax?;
    decimal retryBackoff?;
    decimal metricsSampleWindow?;
    int metricsNumSamples?;
    decimal requestTimeout?;
    decimal connectionMaxIdleTime?;
    int maxPollRecords?;
    int maxPollInterval?;
    decimal reconnectBackoffTime?;
    decimal pollingTimeout?;
    decimal pollingInterval?;
    int concurrentConsumers?;
    decimal defaultApiTimeout?;

    boolean autoCommit = true;
    boolean checkCRCS = true;
    boolean excludeInternalTopics = true;
    boolean decoupleProcessing = false;

    SecureSocket secureSocket?;
    AuthenticationConfiguration authenticationConfiguration?;
    SecurityProtocol securityProtocol = PROTOCOL_PLAINTEXT;
|};

# Type related to consumer record.
#
# + key - Key that is included in the record
# + value - Record content
# + timestamp - Timestamp of the record, in milliseconds since epoch
# + offset - Topic partition position in which the consumed record is stored
public type ConsumerRecord record {|
    byte[] key?;
    byte[] value;
    int timestamp;
    PartitionOffset offset;
|};

# Details related to the producer record.
#
# + topic - Topic to which the record will be appended
# + key - Key that is included in the record
# + value - Record content
# + timestamp - Timestamp of the record, in milliseconds since epoch
# + partition - Partition to which the record should be sent
public type ProducerRecord record {|
    string topic;
    byte[] key?;
    byte[] value;
    int timestamp?;
    int partition?;
|};

# Represents a generic Avro record. This is the type of the value returned from an Avro deserializer consumer.
public type AvroGenericRecord record {
    // Left blank intentionally.
};

// Producer-related records
# Represents the Kafka Producer configuration.
#
# + bootstrapServers - List of remote server endpoints of Kafka brokers
# + acks - Number of acknowledgments
# + compressionType - Compression type to be used for messages
# + clientId - Identifier to be used for server side logging
# + metricsRecordingLevel - Metrics recording level
# + metricReporterClasses - Metrics reporter classes
# + partitionerClass - Partitioner class to be used to select the partition to which the message is sent
# + interceptorClasses - Interceptor classes to be used before sending records
# + transactionalId - Transactional ID to be used in transactional delivery
# + schemaRegistryUrl - Avro schema registry URL. Use this field to specify the schema registry URL if the Avro
#                       serializer is used
# + additionalProperties - Additional properties for the property fields not provided by Ballerina Kafka module. Use
#                          this with caution since this can override any of the fields. It is not recomendded to use
#                          this field except in an extreme situation
# + bufferMemory - Total bytes of memory the producer can use to buffer records
# + retryCount - Number of retries to resend a record
# + batchSize - Maximum number of bytes to be batched together when sending records.
#               Records exceeding this limit will not be batched. Setting this to 0 will disable batching.
# + linger - Delay (in seconds) to allow other records to be batched before sending them to the Kafka server
# + sendBuffer - Size of the TCP send buffer (SO_SNDBUF)
# + receiveBuffer - Size of the TCP receive buffer (SO_RCVBUF)
# + maxRequestSize - The maximum size of a request in bytes
# + reconnectBackoffTime - Time (in seconds) to wait before attempting to reconnect
# + reconnectBackoffMaxTime - Maximum amount of time in seconds to wait when reconnecting
# + retryBackoffTime - Time (in seconds) to wait before attempting to retry a failed request
# + maxBlock - Maximum block time (in seconds) during which the sending is blocked when the buffer is full
# + requestTimeout - Wait time (in seconds) for the response of a request
# + metadataMaxAge - Maximum time (in seconds) to force a refresh of metadata
# + metricsSampleWindow - Time (in seconds) window for a metrics sample to compute over
# + metricsNumSamples - Number of samples maintained to compute the metrics
# + maxInFlightRequestsPerConnection - Maximum number of unacknowledged requests on a single connection
# + connectionsMaxIdleTime - Close the idle connections after this number of seconds
# + transactionTimeout - Timeout (in seconds) for transaction status update from the producer
# + enableIdempotence - Exactly one copy of each message is written to the stream when enabled
# + secureSocket - Configurations related to SSL/TLS encryption
# + authenticationConfiguration - Authentication-related configurations for the Kafka producer
# + securityProtocol - Type of the security protocol to use in the broker connection
public type ProducerConfiguration record {|
    string bootstrapServers;
    ProducerAcks acks = ACKS_SINGLE;
    CompressionType compressionType = COMPRESSION_NONE;
    string clientId?;
    string metricsRecordingLevel?;
    string metricReporterClasses?;
    string partitionerClass?;
    string interceptorClasses?;
    string transactionalId?;

    string schemaRegistryUrl?;

    map<string> additionalProperties?;

    int bufferMemory?;
    int retryCount?;
    int batchSize?;
    decimal linger?;
    int sendBuffer?;
    int receiveBuffer?;
    int maxRequestSize?;
    decimal reconnectBackoffTime?;
    decimal reconnectBackoffMaxTime?;
    decimal retryBackoffTime?;
    decimal maxBlock?;
    decimal requestTimeout?;
    decimal metadataMaxAge?;
    decimal metricsSampleWindow?;
    int metricsNumSamples?;
    int maxInFlightRequestsPerConnection?;
    decimal connectionsMaxIdleTime?;
    decimal transactionTimeout?;

    boolean enableIdempotence = false;

    SecureSocket secureSocket?;
    AuthenticationConfiguration authenticationConfiguration?;
    SecurityProtocol securityProtocol = PROTOCOL_PLAINTEXT;
|};

# Defines a record to send data using Avro serialization.
#
# + schemaString - The string, which defines the Avro schema
# + dataRecord - Records, which should be serialized using Avro
public type AvroRecord record {|
    string schemaString;
    anydata dataRecord;
|};
