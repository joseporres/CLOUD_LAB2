import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;

import java.util.Arrays;

public class WordCount {

    public static void main(String[] args) {

        // Configuramos Spark
        SparkConf conf = new SparkConf().setAppName("WordCount");
        JavaSparkContext sc = new JavaSparkContext(conf);

        // Leemos el archivo de entrada y contamos las palabras
        JavaRDD<String> input_file = sc.textFile(args[0]);
        JavaRDD<String> words = input_file.flatMap(line -> Arrays.asList(line.split(" ")).iterator());
        JavaRDD<Tuple2<String, Integer>> word_counts = words.mapToPair(word -> new Tuple2<>(word, 1)).reduceByKey((a, b) -> a + b);

        // Ordenamos los resultados por frecuencia de aparición de la palabra
        JavaRDD<Tuple2<String, Integer>> word_counts_sorted = word_counts.sortBy(pair -> pair._2, false);

        // Escribimos los resultados en un archivo de salida
        word_counts_sorted.saveAsTextFile(args[1]);

        // Paramos Spark
        sc.stop();
    }
}
