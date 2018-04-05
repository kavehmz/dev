use JSON;
use File::Basename;
my $dirname = dirname(__FILE__);

chdir $dirname;

my $token = `cat secret/github_token`;
my $orgs = $ARGV[0] || "(kavehmz|kmzarc|enoox)";

chomp $token;
my $repos = [];
my $a;
my $page = 1;
while ($a = JSON::from_json(`curl --silent 'https://api.github.com/user/repos?access_token=$token&page=$page'`) and (scalar @$a>0))
{
	print "page $page\n";
	$page++;
	push @{$repos}, @$a;
}

my $authorized_repos = {};
foreach my $k (@{$repos}) {
	$count++;
	my $fn = lc $k->{full_name};
	print "Cloning $fn: [",$count, "/", scalar @$repos, "]\n";
	$authorized_repos->{"../projects/src/github.com/$fn"} = 1;

	if ($fn !~ /^$orgs/) {
		print "Skipping [$fn]\n";
		next;
	}
	next if (-d "../projects/src/github.com/$fn");
	print `git clone https://$token\@github.com/$fn ../projects/src/github.com/$fn`;
}

foreach my $fn (split "\n", `find ../projects/src/github.com/ -maxdepth 2 -mindepth 2 -type d `) {
	next if ($fn !~ /^\.\.\/projects\/src\/github\.com\/$orgs/);

	if (not exists $authorized_repos->{$fn}) {
		print "You have no access to this repo anymore!! : $fn\n";
	}
}
