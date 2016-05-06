use GTK::Simple;
# `CapturingOutput` was a monitor in my code, but even with a class, it errors
#use OO::Monitors;

class CapturingOutput {
  has Supplier $.supplier .= new;

  method print(*@str) {
    # doesn't error without this line
    $.supplier.emit($_) for @str;
  }

  method flush { }

  method supply { $.supplier.Supply }
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
