20-Sep-2002


The ZIP archive of which this README is a part contains
example data for the book Mastering Oracle SQL. When we
published this book, I originally wanted to provide a
coherent set of example data on our website that readers
could use to reproduce the authors' examples on their own
systems. Under pressure to meet the deadline for the book,
I let people talk me out of those examples. I regret and
apologize for that decision. The lack of example data has
been a great sore point with readers, and is the only
blemish on an otherwise well-received book.

The archive you've just unzipped is the authors' and my
best attempt to remedy our earlier mistake. The authors
have spent a great deal of time reverse-engineering example
data from the printed examples in the book. Because the
examples were never rationalized to all use the same set of
example data, we've been forced to provide different sets
of data for the different chapters in the book. Use the
mos_ddl.sql script, described in the table below, to create
the tables used in all the examples. Then run the
chapter-specific script for whatever chapter you are
currently reading. Each chapter-specific script will delete
any existing data before populating the tables anew with
data customized for that chapter's examples.

The authors and I sincerely hope you find these scripts
helpful as you read and test the examplse in the book.
should you encounter any problems with any of the sample
data, please contact the authors, or myself, using one of
the following email addresses:

	Sanjay Mishra - sanjay.mishra@i2.com
	Alan Beaulieu - apbsol@yahoo.com

	Jonathan Gennick - jgennick@oreilly.com (the editor)

Your best bet is to contact the authors first. If for some
reason you can't reach any of us, you can also contact
booktech@oreilly.com. They will do their best to put you in
touch with someone who can help.

Thanks for purchasing Mastering Oracle SQL. It's one of my
favorite books out of all those I've edited.

Jonathan Gennick
Editor
O'Reilly & Associates


Script 			Purpose
==================      =====================================
mos_ddl.sql             To create the tables/views used in
                        the book
ch1_2_5_9_data.sql      To create the data used in Chapters
                        1, 2, 5, and 9
ch3_data.sql		To create the data used in Chapter 3
ch4_data.sql		To create the data used in Chapter 4
ch7_data.sql		To create the data used in Chapter 7
ch8_data.sql		To create the data used in Chapter 8
ch12_data.sql		To create the data used in Chapter 12
ch13_data.sql		To create the data used in Chapter 13
ch14_data.sql		To create the data used in Chapter 14


Chapter 6 doesn't depend on any existing data in the tables
as it mostly uses the DUAL table and INSERT statements on
other tables.

Chapters 10 and 11 do not use common tables and data.


To execute these scripts, you need to first connect to
sqlplus by supplying your user_id, password, and a
connect_string. Once, connected, you can execute each of
these scripts using the SQL*Plus @ command.

    @<SCRIPT_PATH>/<SCRIPT_NAME>

where SCRIPT_PATH is the path (drive and directory) where
you have put these files, and SCRIPT_NAME is the name of
the script you want to execute.

For example, to create the tables, execute the mos_ddl.sql
script as follows:

    SQL> @D:\sanjay_mishra\mos\mos_ddl.sql

Please feel free to contact us if you have questions or
encounter difficulties.

