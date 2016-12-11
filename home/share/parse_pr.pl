use JSON;
use POSIX qw( strftime );

$c='';
while (<STDIN>) {$c.=$_} 

$c=JSON::from_json($c);

$GIT_TOKEN=`cat /home/share/secret/github_token`;
chomp $GIT_TOKEN;

for $i (sort { $a->{updated_at} cmp  $b->{updated_at}} @$c) {
    print $i->{updated_at}, ', ', $i->{html_url}, ', ', $i->{user}->{login}, ', ', $i->{head}->{ref}, "\n";
    if ($i->{updated_at} lt strftime("%Y-%m-%d", localtime(time-86400*35) ) ) {
        if ($ARGV[0] eq 'close') {
            print "\n Closing ", $i->{html_url}," \n";
            $url=$i->{url};
            `curl --data '{"state": "closed"}' --silent '$url?access_token=$GIT_TOKEN'`;
        }
    }
}
