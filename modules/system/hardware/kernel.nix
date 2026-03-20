{
  pkgs,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    # Tweaks inspirés du kernel zen, reproduits manuellement sur mainline
    kernelModules = [ "tcp_bbr" ];

    kernel.sysctl = {
      # Scheduler
      # Désactive le regroupement automatique des tâches par session (nuit à la latence desktop)
      "kernel.sched_autogroup_enabled" = 0;

      # Mémoire
      # Réduit l'utilisation du swap au profit du cache RAM
      "vm.swappiness" = 10;
      # Réduit la tendance du kernel à reclaimer le cache d'inodes/dentries
      "vm.vfs_cache_pressure" = 50;
      # Seuil absolu de dirty pages avant écriture synchrone (256 Mo)
      "vm.dirty_bytes" = 268435456;
      # Seuil absolu déclenchant l'écriture asynchrone en arrière-plan (64 Mo)
      "vm.dirty_background_bytes" = 67108864;
      # Intervalle de flush des dirty pages en centisecondes (15 s)
      "vm.dirty_writeback_centisecs" = 1500;
      # Nombre maximum de zones mémoire mappées par processus (requis pour les gros jeux)
      "vm.max_map_count" = 16777216;
      # Désactive la compaction mémoire proactive pour éviter les latences imprévisibles
      "vm.compaction_proactiveness" = 0;

      # Réseau
      # Algorithme de contrôle de congestion TCP (BBR = meilleur débit et latence)
      "net.ipv4.tcp_congestion_control" = "bbr";
      # Discipline de file d'attente réseau associée à BBR
      "net.core.default_qdisc" = "fq";
      # Taille maximale du buffer de réception socket (16 Mo)
      "net.core.rmem_max" = 16777216;
      # Taille maximale du buffer d'émission socket (16 Mo)
      "net.core.wmem_max" = 16777216;
    };
  };
}
