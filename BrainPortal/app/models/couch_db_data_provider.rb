
#
# CBRAIN Project
#
# Copyright (C) 2008-2012
# The Royal Institution for the Advancement of Learning
# McGill University
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#
# This this is an abstract class which represents data providers
# where the remote files are not even remote, they are local
# to the currently running rails application.
#
# Subclasses are not meant to cache anything! The 'remote' files
# are in fact all local, and accessing the 'cached' files means
# accessing the real provider's files. All methods are adjusted
# so that their behavior is sensible.
#
# Not all API methods are defined here so this class is not meant
# to be instantiated directly.
#
# For the list of API methods, see the DataProvider superclass.
class CouchDBDataProvider < DataProvider

  Revision_info=CbrainFileRevision[__FILE__] #:nodoc:

  def is_browsable?(by_user = nil) #:nodoc:
    return true if by_user.blank? || self.meta[:browse_gid].blank?
    return true if by_user.is_a?(AdminUser) || by_user.id == self.user_id
    by_user.is_member_of_group(self.meta[:browse_gid].to_i)
  end
  
  # This returns the category of the data provider -- used in view for admins
  def self.pretty_category_name
    "Other Types"
  end
  
  # This method must not block, and must respond quickly.
  # Returns +true+ or +false+.
  def impl_is_alive? #:nodoc:
    raise "TODO"
  end

  # Synchronizes the content of +userfile+ as stored
  # on the provider into the local cache.
  def impl_sync_to_cache(userfile) #:nodoc:
    raise "TODO"
  end

  # Synchronizes the content of +userfile+ from the
  # local cache back to the provider.
  def impl_sync_to_provider(userfile) #:nodoc:
    raise "TODO"
  end

  # Deletes the content of +userfile+ on the provider side.
  def impl_provider_erase(userfile) #:nodoc:
    raise "TODO"
  end

  # Renames +userfile+ on the provider side.
  # The method returns true if the rename operation was successful.
  def impl_provider_rename(userfile,newname) #:nodoc:
    raise "Error: method not yet implemented in subclass."
  end
    
  # This method provides a way for a client of the provider
  # to get a list of files on the provider's side, files
  # that are not necessarily yet registered as +userfiles+.
  #
  # When called, the method accesses the provider's side
  # and returns an array of objects. These objects should
  # respond to the following accessor methods that describe
  # a remote file:
  #
  # name:: the base filename
  # symbolic_type:: one of :regular, :symlink, :directory
  # size:: size of file in bytes
  # permissions:: an int interpreted in octal, e.g. 0640
  # uid::  numeric uid of owner
  # gid::  numeric gid of the file
  # owner:: string representation of uid, the owner's name
  # group:: string representation of gid, the group's name
  # mtime:: modification time (an int, since Epoch)
  # atime:: access time (an int, since Epoch)
  # ctime:: attribute change time (an int, since Epoch)
  #
  # These attributes match those of the class
  #     Net::SFTP::Protocol::V01::Attributes
  # except for name() which is new.
  #
  # Not all these attributes need to be filled in; nil
  # is often acceptable for some of them. The bare minimum
  # is probably the set 'name', 'type' and 'size' and 'mtime'.
  #
  # The optional user object passed in argument can be used
  # to restrict the list of files returned to only those
  # that match one of the user's properties (e.g. ownership
  # or file location).
  #
  # Note that not all data providers are meant to be browsable.
  def impl_provider_list_all(user=nil) #:nodoc:
    raise "TODO"
  end

  # Provides information about the files associated with a Userfile entry
  # whose actual contents are still only located on a DataProvider (i.e. it has not
  # been synced to the local cache yet).
  # Though this method will function on SingleFile objects, it is primarily meant
  # to be used on FileCollections to gather information about the individual files
  # in the collection.
  #
  # *NOTE*: this method should gather its information WITHOUT doing a local sync.
  #
  # When called, the method accesses the provider's side
  # and returns an array of FileInfo objects.
  def impl_provider_collection_index(userfile, directory = :all, allowed_types = :regular) #:nodoc:
    raise "TODO"
  end

  # Opens a filehandle to the remote data file and supplies
  # it to the given block. THIS METHOD IS TO BE AVOIDED;
  # the proper methodology is to cache a file before accessing
  # it locally. This method is meant as a workaround for
  # exceptional situations when syncing is not welcome.
  def impl_provider_readhandle(userfile, *args) #:nodoc:
    raise "Error: method not yet implemented in subclass."
  end

end

