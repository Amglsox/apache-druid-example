import threading

from kafka import KafkaProducer
from kafka.producer.future import FutureRecordMetadata


class Producer(threading.Thread):
    def __init__(self, data: str) -> None:
        self.data = data
        self.kafka_topic = "events_web_official_final_3"
        self.bootstrap_servers = "localhost:9092"

    def run(self) -> None:
        """Executa classe produtora de dados para Tópico Kafka"""
        producer = KafkaProducer(
            bootstrap_servers=self.bootstrap_servers,
            value_serializer=lambda v: str(v).encode("utf-8"),
        )
        future = producer.send(self.kafka_topic, self.data)
        future.add_callback(self.on_send_success)
        future.add_errback(self.on_send_error)

        # block until all async messages are sent
        producer.flush()

        # configure multiple retries
        producer = KafkaProducer(retries=5)

    def on_send_success(self, future: FutureRecordMetadata) -> None:
        """Callback para envio de mensagens com sucesso ao Kafka"""
        pass

    def on_send_error(self, excp: str) -> str:
        """Callback para envio de mensagens com falha ao Kafka"""
        return f"I am an errback {excp}"
        # handle exception
