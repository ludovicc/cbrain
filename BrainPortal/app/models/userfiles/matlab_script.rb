#
# CBRAIN Project
#
# Matlab script file model
#
# Original author: Tarek Sherif
#
# $Id$
#

class MatlabScript < TextFile

  Revision_info="$Id$"
  
  def self.file_name_pattern
    /\.m$/i
  end

end