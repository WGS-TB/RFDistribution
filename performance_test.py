import RF
from ete3 import Tree
import time
import os
import csv
import logging

logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.INFO)


def time_tree(newick):
    tree = Tree(newick)
    t0 = time.time()
    sum3_dt = RF.polynomial_sum3_performance(tree, tree.get_leaves().__len__() + 1)[1]
    tf = time.time()
    return tf - t0, sum3_dt


performance_test_directory = 'TreePerformanceTest/'
treeset_performances = {}
files = sorted(os.listdir(performance_test_directory))
logging.info("Filenames loaded.")
logging.info("Begin performance testing.")
time.sleep(0.1)
for i, filename in enumerate(files):
    print("Scanning " + str(i) + " out of " + str(files.__len__()) + " files. [" + str(
        ((i + 1) / files.__len__()) * 100)[0:5] + "%]")
    if filename.endswith(".tre"):
        print("Running performance test on " + filename)
        f = open(performance_test_directory + filename)
        lines = f.read()
        tree_name = filename[0:filename.find("_")]
        if tree_name not in treeset_performances:
            treeset_performances[tree_name] = [""], ["T_poly"], ["T_con"]
        treeset_performances[tree_name][0].append("tree" + filename[filename.find("_") + 1:filename.find(".")])
        dt, sum3_dt = time_tree(lines)
        treeset_performances[tree_name][1].append(dt)
        treeset_performances[tree_name][2].append(sum3_dt)
    else:
        logging.info("Skipping " + filename + " because is not a .tre file.")
logging.info("Finish performance test. Writing to file...")
for key in treeset_performances.keys():
    labels = treeset_performances[key][0]
    T_poly_times = treeset_performances[key][1]
    T_con_times = treeset_performances[key][2]
    new_filename = 'performance_results/M' + key[4:] + '.csv'
    logging.info("Writing to " + new_filename)
    with open(new_filename, mode='w') as performance_file:
        writer = csv.writer(performance_file, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
        writer.writerow(labels)
        writer.writerow(T_poly_times)
        writer.writerow(T_con_times)
logging.info("Finish writing results to files. Find results in " + os.getcwd() + "/performance_results")
