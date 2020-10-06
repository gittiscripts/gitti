########
##
#  fix:
#   move to sportdb/setup   or sportdb/boot ?
#   use module SportDb::Boot



##########
#  setup load path
#     lets you use environments
#     e.g. dev/development or production


## todo/fix: move later app/gem-family/-specific configs
##   to its own gem e.g. mono-sportdb or sportdb-boot/starter/startup or such - why? why not?





$RUBYLIBS_DEBUG = true
$RUBYCOCO_DEBUG = true    ## always include (NOT just in sportdb?)



TRUE_VALUES = [
  'true', 't',
  'yes', 'y',
  'on'
]

### include / check for ruby debug flag too - why? why not?
def debug?     ## always include (NOT just insportdb?)
  value = ENV['DEBUG']
  if value && TRUE_VALUES.include?( value.downcase )
    true
  else
    false
  end
end


require_relative '../mono'



## convenience pre-configured/pre-built shortcut - lets you use
##    require 'sportdb/setup'
##    SportDb::Boot.setup


module SportDb
module Boot
  def self.root()  Mono.root; end

  def self.setup   ## setup load path
### note: for now always assume dev/development
###   add ENV check later or pass in as args or such

    puts "SportDb::Boot.root: >#{root}<"

    ### todo/fix: use an inline Gemfile and bundler's setup? why? why not?
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-exporters/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-writers/lib" )
    $LOAD_PATH.unshift( "#{root}/yorobot/sport.db.more/sportdb-linters/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sports/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-importers/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-readers/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-sync/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-models/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-catalogs/lib" )

    ## todo/check:
    ##   add fifa, footballdb-leagues, footballdb-clubs too ???
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/footballdb-clubs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/footballdb-leagues/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/football.db/fifa/lib" )

    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-structs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/sportdb-langs/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/score-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/date-formats/lib" )
    $LOAD_PATH.unshift( "#{root}/sportdb/sport.db/alphabets/lib" )

    pp $:  # print load path
    end  # method setup
end # module Boot
end # module Sportdb


### use something like SportDb::Path[:sportdb]
##                     SportDb.path( :sportdb )
##                     SportDb::Boot.sportdb_path or sportdb_dir or such???
##                     SportDb::Env.path( 'sportdb' )  ???
##                     SportDb::Env::SPORTDB_DIR ???
##                     or such - why? why not?
##
##  check rails path setup / style ???

SPORTDB_DIR      = "#{SportDb::Boot.root}/sportdb"     # path to libs
OPENFOOTBALL_DIR = "#{SportDb::Boot.root}/openfootball"
## add more "standard" dirs - why? why not? - why? why not?
##   use
##  module SportDb::Source / Code / Boot or such????
##
##  use module SportDb::Boot  - yes, yes, yes - why? why not?

