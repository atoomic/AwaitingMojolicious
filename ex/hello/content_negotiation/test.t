use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Mojo::File 'curfile';

my $t = Test::Mojo->new(curfile->sibling('app.pl'));

# sample(root)
$t->get_ok('/')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting .user' => '🌐');

$t->get_ok('/.txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello 🌐!');

$t->get_ok('/.json')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is({hello => '🌐!'});
# end-sample

# sample(user)
$t->get_ok('/Graham')
  ->status_is(200)
  ->content_type_like(qr'text/html')
  ->text_is('#greeting .user' => 'Graham');

$t->get_ok('/Leo.txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Leo!');

$t->get_ok('/Brad.json')
  ->status_is(200)
  ->content_type_like(qr'application/json')
  ->json_is('/hello' => 'Brad!');
# end-sample

# sample(others)
$t->get_ok('/Thomas', {Accept => 'text/plain'})
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Thomas!');

$t->get_ok('/Shawn?format=txt')
  ->status_is(200)
  ->content_type_like(qr'text/plain')
  ->content_is('Hello Shawn!');
# end-sample

done_testing;

