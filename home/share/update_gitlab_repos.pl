use JSON;

my $content = `cat /home/share/secret/gitlab_token`;
$content =~ /(.*):(.*)/;
my $token = $1;
my $site = $2;

chomp $token;
my $repos = [];
my $a;
my $page = 1;
while ($a = JSON::from_json(`curl --silent 'https://$site/api/v3/projects?per_page=100&private_token=$token&page=$page'`) and (scalar @$a>0))
{
	print "page $page\n";
	$page++;
	push @{$repos}, @$a;
}

my $authorized_repos = {};
foreach my $k (@{$repos}) {
	$count++;
	my $fn = $k->{path_with_namespace};
	print "Cloning $fn: [",$count, "/", scalar @$repos, "]\n";
	$authorized_repos->{"/home/projects/src/$site/$fn"} = 1;

	next if (-d "/home/projects/src/$site/$fn");
	print `git clone git\@$site:$fn.git /home/projects/src/$site/$fn`;
}

foreach my $fn (split "\n", `find /home/projects/src/$site/ -maxdepth 2 -mindepth 2 -type d `) {
	if (not exists $authorized_repos->{$fn}) {
		print "You have no access to this repo anymore!! : $fn\n";
	}
}
