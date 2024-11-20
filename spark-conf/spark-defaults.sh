spark.master yarn

spark.driver.port           7001
spark.fileserver.port       7003
spark.broadcast.port        7004
spark.replClassServer.port  7005
spark.blockManager.port     7006
spark.executor.port         7007
spark.ui.port               4040

spark.broadcast.factory org.apache.spark.broadcast.HttpBroadcastFactory
