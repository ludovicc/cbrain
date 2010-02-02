
#
# CBRAIN Project
#
# This is a replacement for the drmaa.rb library; this particular subclass
# of class Scir implements the Sharcnet interface. They have their
# own custom scripts for submitting and querying the cluster (sqsub, sqjobs, etc).
#
# Original author: Pierre Rioux
#
# $Id$
#

require 'scir'

class ScirSharcnetSession < Scir::Session

  Revision_info="$Id$"

  # Register ourselves as the real implementation for Scir::Session
  Scir.session_subclass = self.to_s

  def update_job_info_cache
    @job_info_cache = {}
    jid = 'Dummy'
    IO.popen("sqjobs -u #{CBRAIN::Rails_UserName} 2>/dev/null;sqjobs -n","r") do |fh|
      fh.readlines.each do |line|

# jobid queue state ncpus prio  nodes time command     
#------ ----- ----- ----- ---- ------ ---- ------------
#169799 nrap1     R     1      wha309 615s ~prioux/x.sh
#2460 CPUs total, 837 idle, 1623 busy; 1251 jobs running; 0 suspended, 11515 queued.
#0 reserved cpus
 
        if line =~ /^(\d+)\s+CPUs.*(\d+)\s+jobs running/
          @job_info_cache['!sharcnet_load!'] = [ Regexp.last_match[2], Regexp.last_match[1] ]  # tot, max
          next
        end

        if line =~ /^(\w\S+)\s+\S+\s+(\S+)/
          jid         = Regexp.last_match[1]
          statestring = Regexp.last_match[2]
          state = statestring_to_stateconst(statestring)
          @job_info_cache[jid.to_s] = { :drmaa_state => state }
        end
      end
    end
  end

  def statestring_to_stateconst(state)
    return Scir::STATE_RUNNING        if state.match(/R/i)
    return Scir::STATE_QUEUED_ACTIVE  if state.match(/Q/i)
    return Scir::STATE_USER_ON_HOLD   if state.match(/H/i)
    return Scir::STATE_USER_SUSPENDED if state.match(/S/i)
    return Scir::STATE_UNDETERMINED
  end

  def hold(jid)
    raise "There is no 'hold' action available on Sharcnet clusters."
  end

  def release(jid)
    raise "There is no 'release' action available on Sharcnet clusters."
  end

  def suspend(jid)
    raise "There is no 'suspend' action available on Sharcnet clusters."
    # does not work on sharcnet (they have bugs...)
    IO.popen("sqsuspend #{shell_escape(jid)} 2>&1","r") do |i|
      p = i.readlines
      raise "Error holding: #{p.join("\n")}" unless p =~ /expect_this/
      return
    end
  end

  def resume(jid)
    raise "There is no 'resume' action available on Sharcnet clusters."
    # does not work on sharcnet (they have bugs...)
    IO.popen("sqresume #{shell_escape(jid)} 2>&1","r") do |i|
      p = i.readlines
      raise "Error releasing: #{p.join("\n")}" unless p =~ /expect_this/
      return
    end
  end

  def terminate(jid)
    IO.popen("sqkill #{shell_escape(jid)} 2>&1","r") do |i|
      p = i.readlines
      raise "Error deleting: #{p.join("\n")}" unless p =~ /is being terminated/
      return
    end
  end

  def queue_tasks_tot_max
    job_ps('!dummy!') # to trigger refresh of @job_ps_cache if necessary
    tot_max = @job_info_cache['!sharcnet_load!'] || [ 'unknown', 'unknown' ]
    tot_max
  rescue
    [ "exception", "exception" ]
  end

  private

  def qsubout_to_jid(txt)
    if txt && txt =~ /as jobid\s+(\S+)/
      return Regexp.last_match[1]
    end
    raise "Cannot find job ID from sqsub output. Got:\n#{txt}\n"
  end

end

class ScirSharcnetJobTemplate < Scir::JobTemplate

  # Register ourselves as the real implementation for Scir::JobTemplate
  Scir.jobtemplate_subclass = self.to_s

  def qsub_command
    raise "Error, this class only handle 'command' as /bin/bash and a single script in 'arg'" unless
      self.command == "/bin/bash" && self.arg.size == 1
    raise "Error: stdin not supported" if self.stdin

    # Prefix: chdir
    command  = ""
    command += "cd #{shell_escape(self.wd)}; "    if self.wd

    # sqsub command
    command += "sqsub "
    command += "-j #{shell_escape(self.name)} "   if self.name
    command += "-o #{shell_escape(self.stdout)} " if self.stdout
    command += "-e #{shell_escape(self.stderr)} " if self.stderr && ! self.join && self.stderr != self.stdout
    command += "-q #{shell_escape(self.queue)} "  if self.queue
    command += " #{CBRAIN::EXTRA_QSUB_ARGS} "     unless CBRAIN::EXTRA_QSUB_ARGS.empty?
    command += "/bin/bash #{shell_escape(self.arg[0])}"
    command += " 2>&1 " # they mix stdout and stderr !!! grrrrrr

    return command
  end

end