#!/usr/bin/python

# Provided by Michael Thon
# Slightly modified by Sergio Alías-Segura to specify outdir (changes marked with #SAS)

from Bio.Blast.NCBIWWW import qblast
from Bio.Blast import NCBIXML
from Bio import SeqIO
from sys import argv
import pdb
import os.path
import argparse
import time
import csv

def parse_cli():
    parser = argparse.ArgumentParser(description="Run a remote blast on NCBI server to check for contamination")
    parser.add_argument('-query',type=str, dest='query', help='query sequences in fasta format')
    parser.add_argument('-taxon', type=str, dest='taxon', help='taxonomic group to filter')
    parser.add_argument('-out', type=str, dest='outdir', help='output directory') #SAS
    args = parser.parse_args()
    return args

options = parse_cli()
prev_seqs = []

outfile_path = os.path.join(options.outdir, os.path.basename(options.query) + '.contamination-report')  #SAS

# check if the output files have sequences in them so we can skip them later
if os.path.isfile(outfile_path): #SAS
    notspecific_h = open(outfile_path, 'r') #SAS
    for row in csv.reader(notspecific_h, delimiter='\t' ):
        #pdb.set_trace()
        print('found previously scanned sequence: ' + row[0])
        prev_seqs.append(row[0])
    notspecific_h.close()




#################### do it
hits_h = open(outfile_path, 'a+') #SAS

seqs_to_blast = []

for seq in SeqIO.parse(open(options.query), 'fasta'):
    #pdb.set_trace()

    if len(seq.seq) > 500:
        subseq = seq[0: 500]
        seqs_to_blast.append((seq.id, str(subseq.seq) ) )

    else:
        seqs_to_blast.append((seq.id, str(seq.seq)))

#pdb.set_trace()
for x in seqs_to_blast:
    if x[0] in prev_seqs:
        print(x[0] + ' already analyzed. skipping...')
        continue
    print('-----------------------------------------')

    print('starting blast for ' + x[0])

    #try:
    result = qblast(program='blastn', sequence=x[1], database='nt', expect='1e-15', hitlist_size= 1,
            entrez_query='all[filter] NOT ' + options.taxon + '[orgn]', megablast=True, service='megablast')
    #pdb.set_trace()
    #except:
    #    print 'some problem with blast.  skipping.'
     #   pdb.set_trace()
    time.sleep(0.5) # this is so a ctrl-c will catch the main thread and not the ncbi blast subprocess
     #   continue
    record = NCBIXML.read(result)
    #pdb.set_trace()

    if len(record.descriptions) > 0:
        #pdb.set_trace()

        desc = record.descriptions[0]
        hits_h.write(x[0] + '\t' + desc.title + '\t' + x[1] + '\n')
        print('possible contamination: '+ x[0] + '\t' + desc.title + '\t' + x[1]+'\n')

    else:
        # no hits. must be species-specific
        hits_h.write(x[0] + '\tno matches\n')

hits_h.close()
print('all done.')
