package main

import (
	"context"
	"io"
	"log"
	"time"

	"github.com/ydb-platform/ydb-go-sdk/v3"
	"github.com/ydb-platform/ydb-go-sdk/v3/topic/topicoptions"
)

func must0(err error) {
	if err != nil {
		panic(err)
	}
}

func must[R any](res R, err error) R {
	must0(err)
	return res
}

func main() {
	ctx := context.Background()
	db := must(ydb.Open(ctx, "grpc://localhost:2135/?database=/local"))
	reader := must(db.Topic().StartReader("consumer", topicoptions.ReadTopic("topic")))
	must(reader.ReadMessage(ctx))
	time.Sleep(time.Second)

	start := time.Now()
	for {
		readCtx, cancel := context.WithTimeout(ctx, time.Second)
		batch, err := reader.ReadMessageBatch(readCtx)
		if readCtx.Err() != nil {
			break
		}
		must0(err)
		cancel()

		for i := range batch.Messages {
			io.Copy(io.Discard, batch.Messages[i])
		}
	}
	finish := time.Now()

	duration := finish.Sub(start) - time.Second
	log.Println("time: ", duration)
}
