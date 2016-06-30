use JSON;

my $token = `cat /home/share/secret/github_token`;
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
	my $fn = $k->{full_name};
	print "Cloning $fn: [",$count, "/", scalar @$repos, "]\n";
	$authorized_repos->{"/home/git/$fn"} = 1;

	if ($fn !~ /^(regentmarkets\/|kavehmz|kmzarc|enoox)/ or ($fn =~ /^kavehmz/ and (grep {$_->{full_name} eq 'regentmarkets/'. $k->{name} } @{$repos}))) {
		print "Skipping [$fn]\n";
		next;
	}
	next if (-d "/home/git/$fn");
	print `git clone https://$token\@github.com/$fn /home/git/$fn`;
	`cd /home/git/$fn;git remote set-url origin git\@github.com:$fn.git`;
}

foreach my $fn (split "\n", `find /home/git/ -maxdepth 2 -mindepth 2 -type d `) {
	if (not exists $authorized_repos->{$fn}) {
		print "You have no access to this repo anymore!! : $fn\n";
	}
}
