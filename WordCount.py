from pyspark import SparkConf, SparkContext
import sys


def word_count(input_file_name, output_file_name):
    conf = SparkConf().setAppName("WordCount")
    sc = SparkContext(conf=conf)

    input_file = sc.textFile(input_file_name)
    word_counts = input_file.flatMap(lambda line: line.split()).map(lambda word: (word, 1)).reduceByKey(lambda a, b: a + b)
    word_counts_sorted = word_counts.sortBy(lambda x: x[1], ascending=False)

    result = word_counts_sorted.collect()

    with open(output_file_name, 'w') as f:
        for word, count in result:
            f.write(u"{}\t{}\n".format(word, count).encode('utf-8'))

# Ejemplo de uso:
word_count(sys.argv[1], sys.argv[2])