import ballerinax/kafka;

service kafka:Service on new kafka:Listener("localhost:9090") {
	remote function onConsumerRecord(kafka:BytesConsumerRecord[] records) returns kafka:Error? {

	}
}
