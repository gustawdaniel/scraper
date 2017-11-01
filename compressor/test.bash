#! /bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")";

path='../raw/all';
limit="$1";

[ -z "$limit" ]\
	&& echo "No limit1"\
	&& exit;

rm -Rf in;
rm -Rf out;
rm -Rf test;

mkdir in;
mkdir out;
mkdir test;

time_a="$(python -c "import time; print time.time();")";

ls -1 $path | shuf | head -n "$limit" | xargs -d "\n" -I '%name%' mv  "$path/%name%" "in/%name%"
cat in/* > /dev/null; # BO MV KLAMIE !!!

time_b="$(python -c "import time; print time.time();")";
python compress.py   dict in  out;
time_c="$(python -c "import time; print time.time();")";
python decompress.py dict out test;
time_d="$(python -c "import time; print time.time();")";

size_in="$(  du -s in   | cut -f 1)";
size_out="$( du -s out  | cut -f 1)";
size_test="$(du -s test | cut -f 1)";
size_dict="$(du -s dict | cut -f 1)";
count="$(ls -1 in | wc -l)";
dict="$(ls -1 dict | wc -l)";
diff="$(diff -qr in test | wc -l)";

cat <<-EOF | python
	time_move = float($time_b)-float($time_a);
	time_comp = float($time_c)-float($time_b);
	time_deco = float($time_d)-float($time_c);
	
	size_in   = float($size_in  )/float(1000);
	size_out  = float($size_out )/float(1000);
	size_test = float($size_test)/float(1000);
	size_dict = float($size_dict)/float(1000);
	
	diff  = $diff;
	count = float($count);
	dict  = $dict;
	
	print 'Time for move: %0.2f s' % time_move;
	print 'Time for compression: %0.2f s' % time_comp;
	print 'Time for decompression: %0.2f s' % time_deco;
	print;
	print 'Compression files per s: %0.2f' % (count/time_comp);
	print 'Compression  MB   per s: %0.2f MB' % (size_in/time_comp);
	print 'Compression size ratio: %0.2f%%' % (100*(1-size_out/size_in));
	print 'Compression dict count: %d' % dict;
	print;
	print 'Files count: %d' % count;
	print 'Files size in: %0.2f MB' % size_in;
	print 'Files size out: %0.2f MB' % size_out;
	print 'Files size test: %0.2f MB' % size_test;
	print 'Files size dict: %0.2f MB' % size_dict;
	print;
	print 'Differences: %d' % diff;
	EOF

[ "$diff" != '0' ]\
	&& diff -qr in test;

