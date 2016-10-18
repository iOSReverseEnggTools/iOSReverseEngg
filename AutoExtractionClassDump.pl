#!/usr/local/bin/perl

my $origDir = "/private/var/mobile/Documents/Dumped";

my $payLoad = $origDir; #TODO need to specify this

my $inDir = $origDir; #."\/"."classDumpZ"; #/private/var/mobile/Documents/Dumped/classDumpZ

my $txtDir = $origDir."\/"."classDumpZ";
#This has *.ipa files
print ("$txtDir \n");
# open the directory classDumpZ
opendir DIR, $inDir or $log->die("Can't open $inDir $!");

# get the list of files in the input directory

my @ipaFiles=sort grep /$inDir\/(.*)\.ipa/, map "$inDir/$_", readdir DIR; #All ipa files starting with com
closedir DIR;
# Now for each file in above.

print @ipaFiles ; #TODO comment after test

my $count = 0;

foreach my $ipaFile (@ipaFiles) {
    #Extract file name
    $ipaFile=~/^(\/.*?\/)([^\/]+)$/;
    $count = $count + 1;

    # $dir has / at the end...
    my ($dir,$fileName)=($1,$2);    
    
    #root# unzip "com.vc.Mingle2-iOS8.0-(Clutch-2.0.4).ipa" -d Mingle2
    my $finalPayload = $payLoad."/"."dir".$count; #This is formed using absolute path of payLoad and filename
   
    print ("For file: $ipaFile, Final payload: $finalPayload\n"); #Debug statement
   
    #in Dumped Directory I run command : unzip like below 
    # root# unzip "com.vc.Mingle2-iOS8.0-(Clutch-2.0.4).ipa" -d Mingle2
    #where unzip "file.ipa what needs to be extrated" -d "foldername"
    #folder name can be extracted from file as dot can be a delimiter(hint)
    
    #create unzip command
    my $unzipCmd = "/usr/bin/unzip \"$ipaFile\" -d \"$finalPayload\""; #TODO absolute path of uzip to be used
    print ("Running: $unzipCmd \n"); #TODO comment after test
    system($unzipCmd); #Any output or error it generates will end up on your screen
    
    #in this Payload directory only one directory would be there with .app named:
    #for this code it is $finalPayload directory

    $finalPayload = $finalPayload."\/"."Payload";
   print ("DEBUG: Payload directory: $finalPayload \n"); 
    opendir ONEDIR, $finalPayload or $log->die("Can't open $finalPayload $!");
    my @oneDir= readdir ONEDIR;
    closedir ONEDIR;
    #in this Payload directory only one directory would be there with .app named:
    # $oneDir[0] is only one because there is only one directory like that
    my $singleDir = $oneDir[2];
  #print @oneDir  ;
   #$singleDir=~/^(\/.*?\/)([^\/]+)$/;
   print ("DEBUG: AppName : $singleDir \n"); 
    #Mingle2.app (need to use dot as delimiter as name without extension is needed for next command
    
    my $subDir = $singleDir; #Mingle2.app
    my $argument=$subDir; #here it will have .app suffix
    #Inside .app directory, I need to run class-dump-z command : 
    
    $argument =~ s /\.app//; #here .app suffix is removed now it is Mingle2
    my $txtFile = $argument."\.txt";
   print ("DEBUG: Argument: $argument\n"); 
my $pathToAppBinary = $finalPayload."/".$singleDir."/".$argument;
print ("DEBUG: Path to Binary : $pathToAppBinary\n");
    my $classDumpCmd  = "/usr/bin/class-dump-z ".$pathToAppBinary." > ".$txtDir."/".$txtFile; 
    print ("Running: $classDumpCmd\n") ; #TODO comment after test
    system($classDumpCmd) ; #TODO uncomment after test
    
}
