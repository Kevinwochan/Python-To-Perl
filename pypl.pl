#!/usr/bin/perl -w

#####################
####### INDEX #######
#####################

# Global variables

## Special Perl Variables
## spaces variable

# Subroutines
## VariableConverter
## printSpaces 
## countSpaces
## compiler 
### comments
### clank lines
### loop control
### print statements
### sys.stdout
### sys.stdin
### while loops
### if statements
### elsif statements
### else
### for loops
### arithemtic operations
### untranslateable lines


######################
## GLOBAL VARIABLES ##
######################

#hash of special perl variables
my %specialPerlVars = (
	'STDIN' => '1',
	'ARGV'=> '1',
);

# variable to store indentation needed
my $spaces = 0;

# hash table stores the arrayNames
my %arrayNames = ();

######################
#### SUBROUTINES #####
######################

# converts python operator funciotns
# e.g things in the format lines.pop 
sub functionOperator {
    my $line = $_[0];
    # seperating out variable from function
    (my $object, my $operation) = $line =~ m/(.*)\.(.*)/;
    $line = "$operation\(\$$object\)";
    # if we use pop or append then the object is a list needing translating
    if ( $operation =~ m/pop/ || $operation =~ m/append/ ) {
        $line =~ s/\$$object/\@$object/    
    }
    return $line;
}

# adds a $ to all python variables unless 
sub variableConverter {
    my $line = $_[0];
    # convert python's array bracketing []
    # to perl array bracketing ()
    $line =~ s/\[/\(/;
    $line =~ s/\]/\)/;
    # match anything starting with a letter followed by alphanumeric
    # characters into an array of variables
    my @variables = $line =~ m/\s*(["']*[a-zA-Z]+?[\w.]*["']*\s*)/g;
    # declare a hash table to store unique variables extracted
 	my %uniqueVariables = ();
    # flag "quoted" indicates current word is isnide quotes thefore it is a string
    my $quoted = 0;
	# apply a $ to all variables in the array ONCE
	# and only if its not a special perl variable
	foreach my $variable ( @variables ) {

        # remove any trailing spaces 
        $variable =~ s/\s+$//;
    
        # converts python array operators like a = lines.pop
        if ( $variable =~ m/\./ ) {
            $newVariable = functionOperator ( $variable );
            $line =~ s/$variable\(\)/$newVariable/;
            next;
        }
        if ( $variable =~ m/^\s*["']/ ) {
            $quoted = 1;
        }
        # if the variable is unique and not within quote marks
        # give it a variable sign '$'
	    if ( ! exists $uniqueVariables{$variable} &&  !$quoted) {
            # if the variable was declared as an array earlier
            # prepend @
            if ( exists $arrayNames{$variable} ) {
                 $line =~ s/$variable/\@$variable/g;
                $uniqueVariables{$variable} = 1;

            # else if the variable is not a special variable  
            }elsif ( ! exists $specialPerlVars{$variable} ) {
                $line =~ s/$variable/\$$variable/g;
                $uniqueVariables{$variable} = 1;
            }
	    }
        if ( $variable =~ m/["']\s*$/ ) { 
            $quoted = 0;
        }

	}
	if ( $line =~ m/sorted\s*\((.*)\)/ ) {
        $variable = $1;
        $line =~ s/\$sorted/sort/;
    }
	# return line with all variables $'d
    return $line;
}

# prints spaces n times for indentation
sub printSpaces {
	my $spaces = $_[0];
	
	for ( my $i = 0; $i < $spaces; $i++ ) {
		print " ";
	}
	
}

# counts the number of spaces hence indentation
sub countSpaces {
	my $line = $_[0];
	my $spaces = 0;
    # check if there is indentation 	
	if ( $line =~ m/^(\s+)/ ) {
	# for each matched indentation space, increment
		$spaces += () = $1 =~  m/\s/g;
	}
	# return the number of spaces
	return $spaces;

}

# closeBraces ( current indentaiton, indentation desired)
#closes off braces until indentation is reached
sub closeBraces {
    my $spaces  = $_[0];
    my $newSpaces = $_[1];
    while ( $spaces > $newSpaces) {
            $spaces -= 4;
            printSpaces( $spaces );
            print "\}\n";
        }
    return $spaces;
}
# replaces python special variables with perl's
# and deletes useless python syntax
# and translates logical operaotrs
# this is used before any of the compiler's if statements
sub pythonFilter{
	
	my $line = $_[0];
	
	# simply deletes typecasts
	if ( $line =~ m/\sint\s*\((.*?)\)/ ) {
		my $typeCasted = $1;
		$line =~ s/int\s*\(.*?\)/$typeCasted/;
	}
	
	if ( $line =~ m/\s*float\s*\((.*?)\)/ ) {
		my $typeCasted = $1;
		$line =~ s/float\s*\(.*?\)/$typeCasted/;
	}

    	
	# converts sys. functions to perl variables
	$line =~ s/sys\.stdin\.readline\(\)/<STDIN>/;
    	
	return $line;
}


# replaces bitwise python with perl's operators
# the $ is added due to another function
sub bitwiseFilter {
    $line = $_[0];
    $line =~ s/\$or / || /g;
    $line =~ s/\$and / && /g;
    $line =~ s/\$not / ! /g;
    return $line;
}
# main translator subroutine
sub compiler {
	
	my $line = $_[0];
	my $spaces = $_[1];

	$line = pythonFilter( $line );

	# doctype declarations
	if ( $line =~ m/^\s*#!\/usr\/bin\/python/ ) {
		
		print "#!/usr/bin/perl -w\n";

	# comments remain unchanged
	} elsif ( $line =~ m/^\s*#/ ) {
		
		printSpaces( $spaces );
		print "$line\n";

	# empty lines or import lib lines
	} elsif ( ( $line =~ m/^\s*$/ ) || ( $line =~ m/^\s*import/ ) ) {
		print "\n";

	# loop controls
	} elsif ( $line =~ m/^\s*[a-z]+$/ ) {
        # break in python becomes last etc 
	    $line =~ s/break/last/;
		$line =~ s/continue/next/;	
		printSpaces( $spaces );
		print "$line\;\n";

	# print statements
	} elsif ( $line =~ m/^\s*print\s*\((.*)\)/ ) {
       	my $toBePrinted = $1; 
        # if we need to print a string (" ") or just a new line ()
		if ( ( $toBePrinted =~ m/^["'].*["']$/ ) || ( $toBePrinted eq "" ) ) {

            # removing any quotes
			$toBePrinted =~ s/['"]//g;
			printSpaces( $spaces );
            # print translated line with \n and ;
			print "print \"$toBePrinted\\n\";\n";

        # else we need to print variables/operations print( )
 		} else {
		    
            # add $ to all variables
			$toBePrinted = variableConverter( $toBePrinted );
			printSpaces( $spaces );
            # print variables with \n appended
			print "print $toBePrinted,\"\\n\";\n";
	    
		}
    
	# sys.stdout.write statements
	} elsif ( $line =~ m/^\s*sys\.stdout\.write\s*\((.*)\)\s*$/ ) {
    
	    my $toBePrinted = $1;
        # if we need to print a string (" ")
	    if ($toBePrinted =~ m/^\".*\"$/) {
	
			$toBePrinted =~ s/\"//g;
			printSpaces( $spaces );
			print "print \"$toBePrinted\"\;\n";
        # else we need to print variables 	
	    } else {
	
			$toBePrinted = variableConverter( $toBePrinted );
			printSpaces( $spaces );
			print "print $toBePrinted\"\;\n";
	
	    }
    # sys.stdin.readlines statements 
	} elsif ( $line =~ m/^\s*(\w+)\s*=\s*sys\.stdin\.readlines\s*\(\)\s*$/ ) {
        	
 		$variable = $1;
        
        #register array under global variable arrayNames
        $arrayNames{$variable} = 1;
	    printSpaces( $spaces );
        # replace $variable = sys...
        # with @variable = <STDIN>
		print "\@$variable = <STDIN>\;\n";
	
	# while loops
	} elsif ( $line =~ m/^\s*while\s*(.*?)\:/) {

	    # #  condition # # 
	    # converts variables
	    my $condition = variableConverter( $1 );
        $condition = bitwiseFilter ( $condition );
	    printSpaces( $spaces );
	    print "while \($condition\) {\n";
	   
		$spaces += 4;

	    # #  inline body # # 
	    if ( $line =~ m/^\s*while\s*.*?\:(.+)$/ ) {
   		    my $body = $1;
			my @lines = $body =~ m/ ([^;]+)\;*/g;
			foreach my $subline ( @lines ) {
				$spaces = compiler ( $subline,$spaces );
			}
            $spaces -= 4;
            printSpaces($spaces);
			print "\}\n";
			
	    }

	# if statements
	} elsif ($line =~ m/^\s*if\s*(.*?)\:(.*)$/) {
	    
		my $condition = $1;
	    my $body = $2;

	    ## condition ## 
	    $condition = variableConverter ( $condition );
        $condition = bitwiseFilter ( $condition );
	    printSpaces($spaces);
	    print "if \($condition\) {\n";

		$spaces += 4;

		## inline body ## 
	    if ( $line =~ m/^\s*if\s*.*?\:(.+)$/ ) {
   		    my $body = $1;
            # seperate inline lines using ';'
			my @lines = $body =~ m/ ([^;]+)\;*/g;
			
			foreach my $subline ( @lines ) {
				$spaces = compiler ( $subline, $spaces );
			}
            $spaces -= 4;
		    printSpaces($spaces);	
			print "\}\n";

	    }
	
	# else if statements
	} elsif ($line =~ m/^\s*elif\s*(.*?)\s*\:(.*)$/) {
	    
		my $condition = $1;
	    my $body = $2;

	    # add a '$' so all variables in the condition 
	    $condition = variableConverter( $condition );
        # print indentation
	    printSpaces( $spaces );
        # print the converted line 
	    print "elsif \($condition\) {\n";
        # increase indentation 
		$spaces += 4;

		# if the elsif statement has a inline body  
	    if ( $line =~ m/^\s*elsif\s*.*?\s*\:(.+)$/ ) {

   		    my $body = $1;
            # seperate each line by ';' into array lines
			my @lines = $body =~ m/ ([^;]+)\;*/g;
            # translate sublines 
			foreach my $subline ( @lines ) {
				$spaces = compiler ( $subline, $spaces );
			}
            
            # close the braces and unindent 
			print "\}\n";
			$spaces -= 4;
	    }
	
	# else statments
	} elsif ( $line =~ m/^\s*else\s*:/) {
	    # print indentation
		printSpaces( $spaces );
        # convert else syntax
		print "else { \n";
        # increase indentation
	    $spaces += 4;
	    
		# if the statement has an inline body 
	    if ( $line =~ m/\:(.+)$/ ) {
        
            my $body = $1;
            # seperate each line by ';'
			my @lines = $body =~ m/ ([^;]+)\;*/g;
	
            # convert each inline line 
			foreach my $subline ( @lines ) {
				$spaces = compiler ( $subline , $spaces );
			}
	        
            # close the else statement and
            # remove indentation
			print "\}\n";
			$spaces -= 4;
	    }

	# for loops
    # for $indexer in range($initial, $limit)
	} elsif ( $line =~ m/^\s*for\s*(\w+)\s*in\s*range\(\s*(.*),\s*(.*)\s*\)/ ) {
	    # extract key information from the line
        my $indexer = $1;
		my $initial = $2;
		my $limit = $3;
	    
        # if the range of the for loop starts with a letter,
        # it's a variable	
		if ( $initial =~ m/^[a-zA-Z]/ ) {
			$initial =  variableConverter( $initial );
		}
		
		if ( $limit =~ m/^[a-zA-Z]/ ) {
			$limit = variableConverter( $limit );
		}
        # print indentation
		printSpaces( $spaces );
        # print translated line, 
        # python's in range function is exclusive 
        # but perl's (..) is inclusive so -1 to limit
		print "foreach \$$indexer ($initial..$limit - 1) { \n";
        
        # increase indentation	
		$spaces += 4;

		# if the statement has an inline body 
	    if ( $line =~ m/for.*?in.*?range.*?\:(.+)$/ ) {
        
            my $body = $1;
            # seperate each line by ';'
			my @lines = $body =~ m/ ([^;]+)\;*/g;
	
            # convert each inline line 
			foreach my $subline ( @lines ) {
				$spaces = compiler ( $subline , $spaces );
			}
	        
            # close the else statement and
            # remove indentation
			print "\}\n";
			$spaces -= 4;
	    }

	# for $line in sys.stdin
	} elsif ( $line =~ m/^\s*for\s*([a-zA-Z]\w+)\s*in\s*sys.stdin/ ) {
	    # extract key information from the line
        my $indexer = $1;
	    
        # print indentation
		printSpaces( $spaces );
        # print translated line, 
        # python's in range function is exclusive 
        # but perl's (..) is inclusive so -1 to limit
		print "foreach \$$indexer (<STDIN>) { \n";
        
        # increase indentation	
		$spaces += 4;

    # convert lsit.append (var) to push (list,var) 
    } elsif ( $line =~ m/\s*(.*)\.append\((.*)\)/ ) {
           my $list = $1;
           my $variable = $2;
            printSpaces ( $spaces );
            print "push (\@$list, $variable)\;\n";

    # convert var = list.index(object) to iteration through list 
    } elsif ( $line =~ m/\s*(\w+)\s*=\s*(\w+)\.index\((.*)\)/ ) {
           my $variable = $1;
           my $list = $2;
           my $object = $3;
           printSpaces ( $spaces );
           print "for( \$index = 0; \$index < scalar(\@$list); \$index = \$index + 1 ) {\n";
           $spaces += 4;
           printSpaces ( $spaces );
               print "if ( \$$list\[\$index\] == $object ) {\n";
               $spaces += 4;
               printSpaces ( $spaces );
               print "\$$variable = \$index\;\n";
               printSpaces ( $spaces );
               print "last\;\n";
           closeBraces ( $spaces-8, $spaces ); 
    
	# arithmetic operations and intialisations
	} elsif ( $line =~ m/[=+>~^&|-]/ ) {
		# adds $ to all variables in the line
		$line = variableConverter ( $line );

        # convert python's chameleon syntax 
        # matcing anything assigned with []
        # to perl's @list
        if ( $line =~ m/([a-zA-Z]+\w*)\s*=\s*\(.*?,.*?\)/ ) {
            $listName = $1;
            # register this variable name as an array in global
            # hashtable of arrayNames
            $arrayNames {$listName} = 1;
            $line =~ s/\$$listName/\@$listName/;
        }
        # convert python's division syntax://
        # to perl's: /
    	$line =~ s/\/\//\//g;
        #convert len python function to perl's scalar
		$line =~ s/\$len\(/scalar(/;
	
        # print indentation	
		printSpaces ( $spaces );
        # print translated line
		print "$line\;\n";
              
	} else {

		print "\# $line\n";

	}
	
	return $spaces;
}




######################
#### MAIN ROUTINE ####
######################

# translates python line by line
foreach my $line (<>) {
	
	my $newSpaces = countSpaces( $line );

	# when indetation decreases, close a brace
	if ( $newSpaces <  $spaces ) {
        $spaces = closeBraces ($spaces , $newSpaces );
	}

	chomp( $line );
	
	# passes line and indentation into translator
	$spaces = compiler( $line, $spaces );
}

# cleans up any unclosed braces
if ( $spaces > 0 ) {
    $spaces = closeBraces ( $spaces, 0 );
}   
