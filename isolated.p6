use GTK::Simple;
use OO::Monitors;

# was a monitor in my code, but even with a class, it errors
class CapturingOutput {
  has Supply $.supply .= new;

  method print(*@str) {
    # doesn't error without this line
    $.supply.emit($_) for @str;
  }

  method flush { }
}

my GTK::Simple::App $app .= new;
$app.set_content(
  my $program-output = GTK::Simple::TextView.new(),
);

my CapturingOutput $c-o .= new;
$c-o.supply.schedule-on(GTK::Simple::Scheduler).tap({
  # doesn't error without this line
  $program-output.text ~= $_;
});
start {
  # doesn't error without this line
  my $*OUT = $c-o;
  say 'hey';
}


$app.run;
