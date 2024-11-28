environment_name = "justinrlee-two-region-cfk"

public_type = "t4g.xlarge"
public_volume_size = 80

instances_r0 = {
  "az1" = {
      public_count = 1,
      private_count = 0,
  },
  "az2" = {
      public_count = 1,
      private_count = 0,
  },
  "az3" = {
      public_count = 0,
      private_count = 0,
  },
}

instances_r1 = {
  "az1" = {
      public_count = 1,
      private_count = 0,
  },
  "az2" = {
      public_count = 1,
      private_count = 0,
  },
  "az3" = {
      public_count = 0,
      private_count = 0,
  },
}
