module ForemanMaintain
  module Cli
    class RestoreCommand < Base
      interactive_option
      parameter 'BACKUP_DIR', 'Path to backup directory to restore',
                :attribute_name => :backup_dir, :completion => { :type => :directory }

      option ['-i', '--incremental'], :flag, 'Restore an incremental backup',
             :attribute_name => :incremental, :completion => { :type => :directory }
      option ['-n', '--dry-run'], :flag,
             'Check if backup could be restored, without performing the restore',
             :attribute_name => :dry_run

      def execute
        scenario = Scenarios::Restore.new(
          :backup_dir => @backup_dir,
          :incremental_backup => @incremental || incremental_backup?,
          :dry_run => @dry_run
        )
        rescue_scenario = Scenarios::RestoreRescue.new
        run_scenario(scenario, rescue_scenario)
        exit runner.exit_code
      end

      def incremental_backup?
        backup = ForemanMaintain::Utils::Backup.new(@backup_dir)
        backup.incremental?
      end
    end
  end
end
