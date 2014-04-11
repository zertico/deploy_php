Facter.add(:checkuser_facter) do
  confine :kernel => :linux
  setcode do
    %x{cat /etc/passwd | cut -f1 -d:}.chomp
  end
end
