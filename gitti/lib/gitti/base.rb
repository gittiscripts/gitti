module Gitti

## raised by Git::Shell.run -- check if top-level ShellError alread exists?
##   use ShellError or RunError - why? why not?
##   and make Git::Shell top-level e.g. Shell - why? why not?
class GitError < StandardError
end


class Git   ## make Git a module - why? why not?

  ###
  ## todo/fix:  change opts=nil to *args or such - why? why not?


  ###############
  ## "setup" starter git commands

  def self.clone( repo, name=nil )
    cmd = "git clone #{repo}"
    cmd << " #{name}"   unless name.nil? || name.empty?
    Shell.run( cmd )
  end

  def self.mirror( repo )
    cmd = "git clone --mirror #{repo}"
    Shell.run( cmd )
  end


  #################
  ## standard git commands

  def self.version
    cmd = 'git --version'
    Shell.run( cmd )
  end

  def self.status( short: false )
    cmd = 'git status'
    cmd << " --short"   if short
    Shell.run( cmd )
  end

  def self.changes  ## same as git status --short  - keep shortcut / alias - why? why not?
    ## returns changed files - one per line or empty if no changes
    cmd = 'git status --short'
    Shell.run( cmd )
  end

  #####################
  ## status helpers

  ## git status --short  returns empty stdout/list
  def self.clean?()   changes.empty?; end

  def self.changes?() clean? == false; end  ## reverse of clean?
  class << self
    alias_method :dirty?, :changes?  ## add alias
  end


  #######
  ## more (major) git commands

  def self.fetch
    cmd = 'git fetch'
    Shell.run( cmd )
  end

  def self.pull
    cmd = 'git pull'
    Shell.run( cmd )
  end

  def self.fast_forward
    cmd = 'git pull --ff-only'
    Shell.run( cmd )
  end
  class << self
    alias_method :ff, :fast_forward   ## add alias
  end


  def self.push
    cmd = 'git push'
    Shell.run( cmd )
  end

  def self.add( pathspec=nil )  ## e.g. git add .  or git add *.rb or such
    cmd = 'git add'
    cmd << " #{pathspec}"   unless pathspec.nil? || pathspec.empty?
    Shell.run( cmd )
  end

  def self.add_all
    cmd = 'git add --all'
    Shell.run( cmd )
  end

  def self.commit( message )
    ### todo/check: make message.nil? an ArgumentError - why? why not?
    ###  if message.nil? || message.empty?

    cmd = 'git commit'
    cmd << %Q{ -m "#{message}"}

    Shell.run( cmd )
  end


  #############
  #  change git ls-files to git ls-tree ... - why? why not?
  ##  - note: git ls-files will include stages files too
  #                not only committed ones!!!
  #
  #  git ls-tree --full-tree --name-only -r HEAD
  #   1)  --full-tree makes the command run as if you were in the repo's root directory.
  #   2)  -r recurses into subdirectories. Combined with --full-tree, this gives you all committed, tracked files.
  #   3)  --name-only removes SHA / permission info for when you just want the file paths.
  #   4)  HEAD specifies which branch you want the list of tracked, committed files for.
  #       You could change this to master or any other branch name, but HEAD is the commit you have checked out right now.
  #
  #   see https://stackoverflow.com/questions/15606955/how-can-i-make-git-show-a-list-of-the-files-that-are-being-tracked
  #
  #  was:

  def self.files  ## was: e.g. git ls-files .  or git ls-files *.rb or such
    ### todo/check: include --full-tree - why? why not?
    ##   will ALWAYS list all files NOT depending on (current) working directory

    cmd = 'git ls-tree --full-tree --name-only -r HEAD'  # was:  'git ls-files'
    Shell.run( cmd )
  end
  ## add list_files or ls_files alias - why? why not?


  ########
  ## query git configuration helpers
  def self.config( prop,
                   show_origin: false,
                   show_scope: false )  ## find a better name e.g. config_get? why? why not?
    cmd = "git config"
    cmd << " --show-origin"   if show_origin
    cmd << " --show-scope"    if show_scope

    if prop.is_a?( Regexp )
      ## note: use Regexp#source
      ##    Returns the original string of the pattern.
      ##      e.g. /ab+c/ix.source #=> "ab+c"
      ##    Note that escape sequences are retained as is.
      ##    /\x20\+/.source  #=> "\\x20\\+"
      cmd << " --get-regexp #{prop.source}"
    else  ## assume string
      cmd << " --get #{prop}"
    end

    Shell.run( cmd )
  end


### add more - why? why not?
##
## def remote_update( opts={} )   ## e.g. git remote update
## command "remote update"
## end

##  todo/check: rename remote to shorthand/shortcut or something or to branch - why, why not??
## def remote_show( name='origin', opts={})  ## e.g. git remote show origin
## command "remote show #{name}"
## end





###
#  use nested class for "base" for running commands - why? why not?
class Shell
def self.run( cmd )
  print "cmd exec >#{cmd}<..."
  stdout, stderr, status = Open3.capture3( cmd )

  if status.success?
    print " OK"
    print "\n"
  else
    print " FAIL (#{status.exitstatus})"
    print "\n"
  end

  unless stdout.empty?
    puts stdout
  end

  unless stderr.empty?
    ## todo/check: or use >2: or &2: or such
    ##  stderr output not always an error (that is, exit status might be 0)
    puts "STDERR:"
    puts stderr
  end

  if status.success?
    stdout   # return stdout string
  else
    puts "!! ERROR: cmd exec >#{cmd}< failed with exit status #{status.exitstatus}:"
    puts stderr

    ### todo/fix:  do NOT use GitError here!!! make it more "general"
    ###   use a Git::Shell.run() wrapper or such - why? why not?
    ##   or use a Shell.git() or Shell.git_run() ???
    ##   or pass in error class - why? why not?
    raise GitError, "cmd exec >#{cmd}< failed with exit status #{status.exitstatus}<: #{stderr}"
  end
end
end # class Git::Shell

end # class Git

end # module Gitti