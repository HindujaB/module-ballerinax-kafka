// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/test;
import ballerina/constraint;
import ballerina/log;
import ballerina/lang.runtime;

public type StringConstraintConsumerRecord record {|
    *AnydataConsumerRecord;
    @constraint:String {
        maxLength: 10
    }
    string key?;
    @constraint:String {
        minLength: 10
    }
    string value;
|};

public type IntConstraintConsumerRecord record {|
    int key?;
    @constraint:Int {
        maxValue: 100,
        minValue: 10
    }
    int value;
    int timestamp;
    PartitionOffset offset;
|};

@constraint:Float {
    maxValue: 100,
    minValue: 10
}
public type Price float;

@constraint:Number {
    maxValue: 100,
    minValue: 10
}
public type Weight decimal;

@constraint:Array {
    minLength: 2,
    maxLength: 5
}
public type NameList int[];

public type Child record {|
    @constraint:String {
        maxLength: 25
    }
    string name;
    @constraint:Int {
        maxValue: 100,
        minValue: 10
    }
    int age;
|};

string receivedIntMaxValueConstraintError = "";
string receivedIntMinValueConstraintError = "";
string receivedNumberMaxValueConstraintError = "";
string receivedNumberMinValueConstraintError = "";
int receivedValidRecordCount = 0;

@test:Config {enable: true}
function stringMinLengthConstraintConsumerRecordTest() returns error? {
    string topic = "string-min-length-constraint-consumer-record-test-topic";
    check sendMessage("This is a long message", topic);
    check sendMessage("Short msg", topic);

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-01",
        clientId: "constraint-consumer-id-01",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    StringConstraintConsumerRecord[]|error result = consumer->poll(1);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function stringMaxLengthConstraintConsumerRecordTest() returns error? {
    string topic = "string-max-length-constraint-consumer-record-test-topic";
    check sendMessage("This is a long message with a short key", topic, "key-01");
    check sendMessage("This is a long message with a long key", topic, "key-00000000000002");

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-02",
        clientId: "constraint-consumer-id-02",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    StringConstraintConsumerRecord[]|error result = consumer->poll(1);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function floatMaxValueConstraintPayloadTest() returns error? {
    string topic = "float-max-value-constraint-consumer-record-test-topic";
    check sendMessage(55.45, topic);
    check sendMessage(1010.45, topic);

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-03",
        clientId: "constraint-consumer-id-03",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    Price[]|error result = consumer->pollPayload(2);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function arrayMaxLengthConstraintPayloadTest() returns error? {
    string topic = "array-max-length-constraint-payload-test-topic";
    check sendMessage([1, 2, 3, 4], topic);
    check sendMessage([1, 2, 3, 4, 5, 6], topic);

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-04",
        clientId: "constraint-consumer-id-04",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    NameList[]|error result = consumer->pollPayload(2);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function arrayMinLengthConstraintPayloadTest() returns error? {
    string topic = "array-min-length-constraint-payload-test-topic";
    check sendMessage([1, 2, 3, 4], topic);
    check sendMessage([1], topic);

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-05",
        clientId: "constraint-consumer-id-05",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    NameList[]|error result = consumer->pollPayload(2);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function floatMinValueConstraintPayloadTest() returns error? {
    string topic = "float-min-value-constraint-consumer-record-test-topic";
    check sendMessage(55.45, topic);
    check sendMessage(1.45, topic);

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-06",
        clientId: "constraint-consumer-id-06",
        offsetReset: OFFSET_RESET_EARLIEST
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    Price[]|error result = consumer->pollPayload(2);
    if result is PayloadValidationError {
        test:assertEquals(result.message(), "Failed to validate");
    } else {
        test:assertFail("Expected a constraint validation error");
    }
    check consumer->close();
}

@test:Config {enable: true}
function intMaxValueConstraintListenerConsumerRecordTest() returns error? {
    string topic = "int-max-value-constraint-listener-test-topic";
    check sendMessage(95, topic);
    check sendMessage(1000, topic);

    Service intConstraintService =
    service object {
        remote function onConsumerRecord(IntConstraintConsumerRecord[] records) returns error? {
            foreach int i in 0 ... records.length() {
                log:printInfo("Received record: " + records[i].toString());
            }
        }

        remote function onError(Error e) {
            log:printError(e.message());
            receivedIntMaxValueConstraintError = e.message();
        }
    };

    ConsumerConfiguration consumerConfiguration = {
        topics: [topic],
        offsetReset: OFFSET_RESET_EARLIEST,
        groupId: "constraint-listener-group-07",
        clientId: "constraint-listener-07",
        pollingInterval: 1
    };
    Listener constraintListener = check new (DEFAULT_URL, consumerConfiguration);
    check constraintListener.attach(intConstraintService);
    check constraintListener.'start();
    runtime:sleep(3);
    check constraintListener.gracefulStop();
    test:assertEquals(receivedIntMaxValueConstraintError, "Failed to validate");
}

@test:Config {enable: true}
function intMinValueConstraintListenerConsumerRecordTest() returns error? {
    string topic = "int-min-value-constraint-listener-test-topic";
    check sendMessage(95, topic);
    check sendMessage(8, topic);

    Service intConstraintService =
    service object {
        remote function onConsumerRecord(IntConstraintConsumerRecord[] records) returns error? {
            foreach int i in 0 ... records.length() {
                log:printInfo("Received record: " + records[i].toString());
            }
        }

        remote function onError(Error e) {
            log:printError(e.message());
            receivedIntMinValueConstraintError = e.message();
        }
    };

    ConsumerConfiguration consumerConfiguration = {
        topics: [topic],
        offsetReset: OFFSET_RESET_EARLIEST,
        groupId: "constraint-listener-group-08",
        clientId: "constraint-listener-08",
        pollingInterval: 1
    };
    Listener constraintListener = check new (DEFAULT_URL, consumerConfiguration);
    check constraintListener.attach(intConstraintService);
    check constraintListener.'start();
    runtime:sleep(3);
    check constraintListener.gracefulStop();
    test:assertEquals(receivedIntMinValueConstraintError, "Failed to validate");
}

@test:Config {enable: true}
function numberMaxValueConstraintListenerPayloadTest() returns error? {
    string topic = "number-max-value-constraint-listener-payload-test-topic";
    check sendMessage(1000.456, topic);

    Service intConstraintService =
    service object {
        remote function onConsumerRecord(Weight[] records) returns error? {
            foreach int i in 0 ... records.length() {
                log:printInfo("Received record: " + records[i].toString());
            }
        }

        remote function onError(Error e) {
            log:printError(e.message());
            receivedNumberMaxValueConstraintError = e.message();
        }
    };

    ConsumerConfiguration consumerConfiguration = {
        topics: [topic],
        offsetReset: OFFSET_RESET_EARLIEST,
        groupId: "constraint-listener-group-09",
        clientId: "constraint-listener-09",
        pollingInterval: 1
    };
    Listener constraintListener = check new (DEFAULT_URL, consumerConfiguration);
    check constraintListener.attach(intConstraintService);
    check constraintListener.'start();
    runtime:sleep(3);
    check constraintListener.gracefulStop();
    test:assertEquals(receivedNumberMaxValueConstraintError, "Failed to validate");
}

@test:Config {enable: true}
function numberMinValueConstraintListenerPayloadTest() returns error? {
    string topic = "number-min-value-constraint-listener-payload-test-topic";
    check sendMessage(3.456, topic);

    Service intConstraintService =
    service object {
        remote function onConsumerRecord(Weight[] records) returns error? {
            foreach int i in 0 ... records.length() {
                log:printInfo("Received record: " + records[i].toString());
            }
        }

        remote function onError(Error e) {
            log:printError(e.message());
            receivedNumberMinValueConstraintError = e.message();
        }
    };

    ConsumerConfiguration consumerConfiguration = {
        topics: [topic],
        offsetReset: OFFSET_RESET_EARLIEST,
        groupId: "constraint-listener-group-10",
        clientId: "constraint-listener-10",
        pollingInterval: 1
    };
    Listener constraintListener = check new (DEFAULT_URL, consumerConfiguration);
    check constraintListener.attach(intConstraintService);
    check constraintListener.'start();
    runtime:sleep(3);
    check constraintListener.gracefulStop();
    test:assertEquals(receivedNumberMinValueConstraintError, "Failed to validate");
}

@test:Config {enable: true}
function validRecordConstraintPayloadTest() returns error? {
    string topic = "valid-record-constraint-listener-payload-test-topic";
    check sendMessage({name: "Phil Dunphy", age: 56}, topic);
    check sendMessage({name: "Claire Dunphy", age: 55}, topic);
    check sendMessage({name: "Hayley Dunphy", age: 20}, topic);
    check sendMessage({name: "Max Dunphy", age: 18}, topic);

    Service validRecordService =
    service object {
        remote function onConsumerRecord(Child[] records) returns error? {
            foreach int i in 0 ... records.length() {
                log:printInfo("Received record: " + records[i].toString());
                receivedValidRecordCount += 1;
            }
        }

        remote function onError(Error e) {
            log:printError(e.message());
        }
    };

    ConsumerConfiguration consumerConfiguration = {
        topics: [topic],
        offsetReset: OFFSET_RESET_EARLIEST,
        groupId: "constraint-listener-group-11",
        clientId: "constraint-listener-11",
        pollingInterval: 1
    };
    Listener constraintListener = check new (DEFAULT_URL, consumerConfiguration);
    check constraintListener.attach(validRecordService);
    check constraintListener.'start();
    runtime:sleep(3);
    check constraintListener.gracefulStop();
    test:assertEquals(receivedValidRecordCount, 4);
}

@test:Config {enable: true}
function disabledConstraintValidationTest() returns error? {
    string topic = "disabled-constraint-validation-test-topic";
    check sendMessage("This is a long message", topic);
    check sendMessage("Short msg", topic, "this-is-a-long-long-key");

    ConsumerConfiguration consumerConfigs = {
        topics: [topic],
        groupId: "constraint-consumer-group-01",
        clientId: "constraint-consumer-id-01",
        offsetReset: OFFSET_RESET_EARLIEST,
        constraintValidation: false
    };
    Consumer consumer = check new (DEFAULT_URL, consumerConfigs);

    StringConstraintConsumerRecord[]|error result = consumer->poll(2);
    if result is error {
        test:assertFail(result.message());
    } else {
        test:assertEquals(result.length(), 2);
        test:assertEquals(result[0].value, "This is a long message");
        test:assertEquals(result[1].value, "Short msg");
        test:assertEquals(result[1].key, "this-is-a-long-long-key");
    }
    check consumer->close();
}
