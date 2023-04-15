meta:
  id: flp
  title: FL Studio file formats
  application: Image-Line FL Studio
  file-extension: ['flp', 'fsc', 'fst']
  ks-version: 0.10
  imports:
    - /common/vlq_base128_le
  license: GPL-3.0-or-later
  endian: le
doc: |
  FL Studio uses a TLV format based on MIDI for storing project and preset
  files. All information is stored in the form of TLV constructs called events
  which can be thought of as flattened object attributes.

  FLP is an undocumented format. There is rarely any information about it,
  except from a note by Didier Dambrin (a.k.a gol, ex Image-Line employee) and
  a list of event IDs and few enums by Image-Line for FL Studio 11.

  Special thanks to @RoadCrewWorker for reversing a significant chunk of the
  FLP format and FLPEdit and to @monadgroup for FLParser. Apart from that, many
  definitions are from my library [PyFLP](https://github.com/demberto/PyFLP)
seq:
  - id: hdr_magic
    contents: "FLhd"
  - id: len_hdr
    contents: [6, 0, 0, 0]
  - id: fmt
    type: s2
    enum: format
  - id: num_channels
    type: u2
  - id: ppq
    type: u2
    valid:
      any-of: [24, 48, 72, 96, 120, 144, 168, 192, 384, 768, 960]
  - id: data_magic
    contents: "FLdt"
  - id: len_events
    type: u4
  - id: events
    type: event
    repeat: eos
instances:
  uses_utf16:
    value: |
      events[0].data.as<event::version>.major >= 11 and
      events[0].data.as<event::version>.minor >= 5
enums:
  bool:
    0: false
    1: true
  format:
    -1:
      id: tmp
      doc: Temporary / invalid file
    0:
      id: project
      doc: FL Studio project (.flp)
    16:
      id: score
      doc: FL Studio score (.fsc)
      doc-ref: https://tinyurl.com/fscfile
    24: automation
    32: channel
    48:
      id: plugin
      doc: Native generator / effect (.fst)
      doc-ref: https://tinyurl.com/fstfile
    49:
      id: generator
      doc: VST instrument (.fst)
      doc-ref: https://tinyurl.com/fstfile
    50:
      id: fx
      doc: VST effect (.fst)
      doc-ref: https://tinyurl.com/fstfile
    64: insert
  id:
    0:
      id: channel_on
      doc: Whether channel is enabled.
      doc-ref: https://tinyurl.com/flschannelmute
    2:
      id: channel_vol1
      doc: Deprecated by `id::channel_vol2`
    3:
      id: channel_pan1
      doc: Deprecated by `id::channel_pan2`
    9: looped
    10:
      id: show_info
      doc: Show information banner on startup
      doc-ref: https://tinyurl.com/flsprojectinfo
    11:
      id: rack_swing
      doc: Global swing
      doc-ref: https://tinyurl.com/flsglobalswing
    12:
      id: main_vol
      doc: Deprecated. Used to be stored, but no longer
      doc-ref: https://tinyurl.com/flsmonitorvolume
    13:
      id: rack_steps
      doc: Deprecated. Removed functionality.
    14: unk14
    15:
      id: channel_zipped
      doc: Found only for channels that are zipped
    17: ts_num
    18: ts_beat
    20:
      id: channel_pploop
      doc-ref: https://tinyurl.com/flssamplerplayback, Ping pong loop
    21: channel_type
    22:
      id: channel_insert
      doc: IID of the insert to which the channel is routed
      doc-ref: https://tinyurl.com/flswrapperpage, 10. Mixer track selector
    23:
      id: pan_law
      doc-ref: https://tinyurl.com/flsprojectadvanced, Panning law
    26: pattern_loop
    28:
      id: licensed
      doc: Whether last saved with a licensed copy of FL Studio
    29:
      id: apdc
      doc: Use automatic plugin delay compensation
    30:
      id: play_cut_notes
      doc: Play truncated notes in (playlist) clips
      doc-ref: https://tinyurl.com/flsprojectadvanced
    31: mixer_31
    32:
      id: channel_locked
      doc: Whether channel is in locked state [FL 12.3+]
      doc-ref: https://tinyurl.com/flschannelmute, Lock state
    33:
      id: timemarker_num
      doc: Time marker numerator
    34:
      id: timemarker_deno
      doc: Time marker denominator
    35: unk_35
    36:
      id: arrangement_36
      doc: Always 0. Open issue if it isn't
    37: unk_37
    38: mixer_38
    39: mixer_39
    40: mixer_40
    41: unk41
    64:
      id: channel_iid
      doc: |
        Channel internal ID, usually the index itself.
        Special cases like tempo automation use a different ID.
    65:
      id: pattern_iid
      doc: Pattern internal ID. Occurs twice for non-empty patterns.
    66:
      id: bpm_coarse
      doc: Deprecated by `id::tempo`
    67:
      id: selected_pattern
      doc: IID of the selected pattern in pattern picker
    69: channel_freqtilt
    70: sampler_fxflags
    71:
      id: sampler_cutoff
      doc-ref: https://tinyurl.com/flssamplerfx, Effects -> Cutoff (CUT)
    72:
      id: channel_vol2
      doc: Deprecated by `channel_levels::vol`
    73:
      id: channel_pan2
      doc: Deprecated by `channel_levels::pan`
    74:
      id: sampler_preamp
      doc-ref: https://tinyurl.com/flssamplerfx, Effects -> Boost
    75:
      id: sampler_fadeout
      doc-ref: https://tinyurl.com/flssamplerfx, Tools -> Fade out (OUT)
    76:
      id: sampler_fadein
      doc-ref: https://tinyurl.com/flssamplerfx, Tools -> Fade in (IN)
    80:
      id: main_pitch
      doc-ref: https://tinyurl.com/flsglobaltuning
    83:
      id: sampler_reso
      doc-ref: https://tinyurl.com/flssamplerfx, Effects -> Resonance (RES)
    85:
      id: sampler_stdly
      doc-ref: https://tinyurl.com/flssamplerfx, Effects -> Stereo Delay
    86:
      id: sampler_pogo
      doc-ref: https://tinyurl.com/flssamplerfx, Effects -> Pitch bend
    89: channel_shift
    93:
      id: bpm_fine
      doc: Deprecated by `id::tempo`
    94:
      id: layer_child
      doc: IID of a layer's child channel
    95: insert_icon
    97: channel_swing
    98:
      id: slot_iid
      doc: Insert slot internal IID. A zero-based index.
    99:
      id: arrangement_iid
      doc: Arrangement internal IID. A zero-based index.
    100:
      id: cur_arrangement
      doc: Currently selected arrangement IID
    128: plugin_color
    131:
      id: sampler_rmod
      doc-ref: https://tinyurl.com/flssamplerfx, Ring modulation
    132: channel_cutgrp
    133:
      id: rack_height
      doc: Height of the channel rack (in pixels)
    135: channel_root
    138:
      id: channel_dlymod
      doc-ref: https://tinyurl.com/flschanneldelay, Cutoff, Resonance
    139:
      id: sampler_reverb
      doc-ref: https://tinyurl.com/flssamplerfx, Effects
    140:
      id: sampler_srtime
      doc: Deprecated by `channel_blob::stretch_time`
    142:
      id: channel_kbfine
      doc: Min = -100. Max = +100. Defaults to 0 (cents)
      doc-ref: https://tinyurl.com/flschannelkeyboard, Fine tuning
    143: sampler_flags
    144:
      id: layer_flags
      doc-ref: https://tinyurl.com/flslayersettings, Layering section
    145:
      id: channel_category
      doc: IID of the category under which the channel is grouped
    146: cur_category
    147:
      id: insert_out
      doc: Insert audio output
      doc-ref: https://tinyurl.com/flsmixercontrols, Audio input & output
    148:
      id: timemarker_pos
      doc: Position of the timemarker in the playlist / pattern
    149: insert_color
    150: pattern_color
    152:
      id: loop_pos
      doc: Deprecated by `id::pl_sel`
    153:
      id: sampler_aurate
      doc: Deprecated. Used to store AU file sample rate
    154:
      id: insert_in
      doc: Insert audio input
      doc-ref: https://tinyurl.com/flsmixercontrols, Audio input & output
    155: plugin_icon
    156:
      id: tempo
      doc: Stored as a number `coarse * 1000 + fine`
      doc-ref: https://tinyurl.com/flstransportpanel, Tempo
    157:
      id: pattern_157
      doc: Always -1. Open issue if it isn't
    158:
      id: pattern_158
      doc: Always -1. Open issue if it isn't
    159:
      id: ver_build
      doc: Contents of `version::build` as an integer
    160:
      id: pattern_chiid
      doc: Probably the channel IID to which the pattern is linked to
    161: unk161
    162: unk162
    163: unk163
    164:
      id: pattern_steps
      doc: Default to 0
      doc-ref: https://tinyurl.com/flspatternlength
    192:
      id: channel_name
      doc: Deprecated by `plugin_name`
    193: pattern_name
    194:
      id: title
      doc: Project title
      doc-ref: https://tinyurl.com/flsprojectinfo
    195:
      id: comment
      doc: Project description
      doc-ref: https://tinyurl.com/flsprojectinfo
    196:
      id: channel_sample
      doc: |
        Absolute path to a a sample file loaded in a Sampler / Audio clip.
        `%FLStudioFactoryData%` is used as a placeholder for stock samples.
    197:
      id: url
      doc-ref: https://tinyurl.com/flsprojectinfo
    198:
      id: rtfcmt
      doc: Comment in RTF format. Deprecated by `id::comment`
    199:
      id: version
      doc: Version of FL Studio this file was last saved with
    200:
      id: licensee
      doc: Jumbled up FL Studio license owner username, updated every save
      doc-ref: https://tinyurl.com/pyflplicensee, encode / decode algorithm
    201:
      id: plugin_factory
      doc: Internal name of a plugin used for parsing `id::plugin_blob`
    202:
      id: datapath
      doc-ref: https://tinyurl.com/flsdatapath
    203:
      id: plugin_name
      doc: Displayed / user assigned name to a channel / insert slot
    204: unk204
    205: timemarker_name
    206:
      id: genre
      doc-ref: https://tinyurl.com/flsprojectinfo
    207:
      id: artists
      doc-ref: https://tinyurl.com/flsprojectinfo
    209: channel_delay
    212: plugin_wrapper
    213: plugin_blob
    215: channel_blob
    216:
      id: initctrls
      doc-ref: https://tinyurl.com/flsprojectbrowser, Initialized controls
    217: pl_sel
    218: channel_envlfo
    219: channel_levels
    220: unk220
    221: channel_polyphony
    222: unk222
    223: pattern_ctrls
    224: pattern_notes
    225: mixer_blob
    226: midictrl
    227:
      id: remotectrl
      doc-ref: https://tinyurl.com/flsprojectbrowser, Remote control
    228: channel_tracking
    229: channel_lvladj
    230: unk230
    231:
      id: category
      doc: Channel filter group. For example, Unsorted, Audio, All etc.
      doc-ref: https://tinyurl.com/flsfiltergroup
    232: unk232
    233: playlist
    234: channel_auto
    235: insert_routing
    236: insert_data
    237: timestamp
    238: track_info
    239: track_name
    240: unk240
    241: arrangement_name
types:
  event:
    seq:
      - id: id
        type: u1
        enum: id
      - id: len
        type: vlq_base128_le
        if: id.to_i >= 192
      - id: data
        size: |
          id.to_i < 64 ? 1 :
          id.to_i < 128 ? 2 :
          id.to_i < 192 ? 4 :
          len.value
        type:
          switch-on: id
          cases:
            'id::apdc': bool
            'id::arrangement_iid': u2
            'id::arrangement_name': pstr
            'id::artists': pstr
            'id::bpm_coarse': u2
            'id::bpm_fine': u2
            'id::category': pstr
            'id::channel_auto': channel_auto
            'id::channel_blob': channel_blob
            'id::channel_category': s4
            'id::channel_cutgrp': channel_cutgrp
            'id::channel_delay': channel_delay
            'id::channel_dlymod': channel_dlymod
            'id::channel_envlfo': channel_envlfo
            'id::channel_freqtilt': u2
            'id::channel_iid': u2
            'id::channel_insert': s1
            'id::channel_kbfine': s4
            'id::channel_on': bool
            'id::channel_levels': channel_levels
            'id::channel_locked': bool
            'id::channel_lvladj': channel_lvladj
            'id::channel_name': pstr
            'id::channel_pan1': s1
            'id::channel_pan2': s2
            'id::channel_polyphony': channel_polyphony
            'id::channel_pploop': bool
            'id::channel_root': u4
            'id::channel_sample': pstr
            'id::channel_swing': u2
            'id::channel_tracking': channel_tracking
            'id::channel_type': channel_type
            'id::channel_vol1': u1
            'id::channel_vol2': u2
            'id::channel_zipped': bool
            'id::comment': pstr
            'id::cur_arrangement': u2
            'id::cur_category': s4
            'id::datapath': pstr
            'id::genre': pstr
            'id::insert_color': color
            'id::insert_data': insert_data
            'id::insert_icon': s4
            'id::insert_in': s4
            'id::insert_out': s4
            'id::insert_routing': insert_routing
            'id::layer_child': u2
            'id::layer_flags': layer_flags
            'id::licensed': bool
            'id::licensee': pstr
            'id::loop_pos': u4
            'id::looped': bool
            'id::main_pitch': u2
            'id::main_vol': u2
            'id::mixer_blob': mixer_blob
            'id::pan_law': pan_law
            'id::pattern_chiid': u4
            'id::pattern_color': color
            'id::pattern_ctrls': pattern_ctrls
            'id::pattern_iid': u2
            'id::pattern_loop': bool
            'id::pattern_name': pstr
            'id::pattern_notes': pattern_notes
            'id::pattern_steps': u4
            'id::play_cut_notes': bool
            'id::playlist': playlist
            'id::plugin_color': color
            'id::plugin_blob': plugin_blob
            'id::plugin_icon': s4
            'id::plugin_factory': pstr
            'id::plugin_name': pstr
            'id::plugin_wrapper': wrapper
            'id::rack_swing': u1
            'id::rack_steps': u1
            'id::rack_height': u4
            'id::rtfcmt': pstr
            'id::sampler_aurate': u4
            'id::sampler_cutoff': u2
            'id::sampler_fadein': u2
            'id::sampler_fadeout': u2
            'id::sampler_flags': sampler_flags
            'id::sampler_fxflags': sampler_fxflags
            'id::sampler_pogo': u2
            'id::sampler_preamp': u2
            'id::sampler_reso': u2
            'id::sampler_reverb': sampler_reverb
            'id::sampler_rmod': sampler_rmod
            'id::sampler_srtime': u4
            'id::selected_pattern': u2
            'id::show_info': bool
            'id::slot_iid': s2
            'id::tempo': tempo
            'id::timemarker_deno': u1
            'id::timemarker_name': pstr
            'id::timemarker_num': u1
            'id::timemarker_pos': u4
            'id::timestamp': timestamp
            'id::title': pstr
            'id::track_info': track_info
            'id::track_name': pstr
            'id::ts_num': u1
            'id::ts_beat': u1
            'id::url': pstr
            'id::version': version
            'id::ver_build': u4
            _: unknown
  unknown:
    seq:
      - size-eos: true
  bool:
    seq:
      - id: value
        type: u1
        enum: bool
  color:
    doc: RGB color. Alpha channel is unused.
    seq:
      - id: red
        type: u1
      - id: green
        type: u1
      - id: blue
        type: u1
      - size: 1
  pstr:
    seq:
      - id: string
        type:
          switch-on: _root.uses_utf16
          cases:
            true: unicode
            false: ascii
    types:
      ascii:
        seq:
          - id: value
            type: str
            size: _parent._io.size - 1
            encoding: ascii
      unicode:
        seq:
          - id: value
            type: str
            size: _parent._io.size - 2
            encoding: utf-16le
  channel_auto:
    seq:
      - size: 4
      - id: lfo_amt
        type: s4
        valid:
          min: -128
          max: 128
        doc: LFO amount
      - size: 9
      - id: num_points
        type: u4
      - id: points
        type: point
        repeat: expr
        repeat-expr: num_points
      - size-eos: true
    types:
      point:
        seq:
          - id: ofs
            type: u4
          - id: value
            type: f8
          - id: tns
            type: f4
            valid:
              min: 0.0
              max: 1.875
          - size: 4
  channel_blob:
    seq:
      - size: 9
      - id: no_dc
        type: u1
        enum: bool
        doc-ref: https://tinyurl.com/flssamplerfx, Remove DC offset
      - id: dly_flags
        type: u1
        enum: dly_flags
      - id: use_main_pitch
        type: u1
        enum: bool
        doc-ref: https://tinyurl.com/flschannelkeyboard, Enable main pitch
      - size: 28
      - id: arp_direction
        type: u4
        enum: arp_direction
      - id: arp_range
        type: u4
      - id: arp_chord
        type: s4
        doc: Defaults to -1
      - id: arp_time
        type: f4
      - id: arp_gate
        type: f4
      - id: arp_slide
        type: u1
        enum: bool
      - size: 1
      - id: full_porta
        type: u1
        enum: bool
      - id: add_root_note
        type: u1
        enum: bool
      - id: time_gate
        type: u2
      - size: 2
      - id: key_region
        type: key_region
      - size: 4
      - id: normalize
        type: u1
        enum: bool
        doc-ref: https://tinyurl.com/flssamplerfx, Normalize
      - id: invert
        type: u1
        enum: bool
        doc-ref: https://tinyurl.com/flssamplerfx, Reverse polarity
      - size: 1
      - id: declick_mode
        type: u1
        enum: declick
        doc-ref: https://tinyurl.com/flssamplerdeclick
      - id: xfade
        type: u4
        valid:
          min: 0
          max: 256
        doc-ref: https://tinyurl.com/flssamplerfx, Crossfade
      - id: trim
        type: u4
        valid:
          min: 0
          max: 256
        doc-ref: https://tinyurl.com/flssamplerfx, Trim threshold
      - id: arp_rep
        type: u4
      - id: stretch_time
        type: u4
        doc-ref: https://tinyurl.com/flstimestretching, Sample duration
      - id: stretch_pitch
        type: s4
        doc-ref: https://tinyurl.com/flstimestretching, Pitch shift
      - id: stretch_mult
        type: s4
        doc-ref: https://tinyurl.com/flstimestretching, Time multiplier
      - id: stretch_mode
        type: s4
        enum: stretch
        doc-ref: https://tinyurl.com/flstimestretching, Stretch method
      - size: 21
      - id: start
        type: f4
        valid:
          min: 0.0
          max: 1.0
        doc-ref: https://tinyurl.com/flssamplerfx, Sample start
      - size: 4
      - id: length
        type: f4
        valid:
          min: 0.0
          max: 1.0
        doc-ref: https://tinyurl.com/flssamplerfx, Length
      - size: 3
      - id: start_ofs
        type: u4
      - size: 5
      - id: fix_trim
        type: u1
        enum: bool
        doc: Fix legacy precomputed length for `trim`
    enums:
      arp_direction:
        0: 'off'
        1: up
        2: down
        3: bounce
        4: sticky
        5: random
      declick:
        0: out_only
        1: no_bleed
        2: transient
        3: generic
        4: smooth
        5: xfade
      dly_flags:
        2: ping_pong
        4: fat_mode
      stretch:
        -1: stretch
        0: resample
        1: e3gen
        2: e3mono
        3: slice_stretch
        4: slice_map
        5: auto
        6: e2gen
        7: e2transient
        8: e2mono
        9: e2speech
    types:
      key_region:
        seq:
          - id: start
            type: u4
          - id: end
            type: u4
  channel_cutgrp:
    seq:
      - id: self_
        type: s2
        valid:
          min: 0
          max: 99
      - id: by
        type: s2
        valid:
          min: 0
          max: 99
  channel_delay:
    seq:
      - id: feedback
        type: u4
        valid:
          min: 0
          max: 25600
      - id: pan
        type: s4
        valid:
          min: -6400
          max: 6400
      - id: shift
        type: s4
        valid:
          min: -1200
          max: 1200
        doc: Pitch shift (in cents)
      - id: echoes
        type: u4
        valid:
          min: 1
          max: 10
      - id: time
        type: u4
  channel_dlymod:
    seq:
      - id: mod_x
        type: u2
        valid:
          min: 0
          max: 256
      - id: mod_y
        type: u2
        valid:
          min: 0
          max: 256
  channel_envlfo:
    seq:
      - id: flags
        type: s4
        enum: flags
      - id: env_on
        type: s4
        enum: bool
      - id: env_pdly
        type: u4
        valid:
          min: 100
          max: 65536
        doc: Envelope predelay. Defaults to minimum
      - id: env_att
        type: u4
        valid:
          min: 100
          max: 65536
        doc: Envelope attack. Defaults to 20000
      - id: env_hold
        type: u4
        valid:
          min: 100
          max: 65536
        doc: Envelope hold. Defaults to 20000
      - id: env_dec
        type: u4
        valid:
          min: 100
          max: 65536
        doc: Envelope decay. Defaults to 30000
      - id: env_sus
        type: u4
        valid:
          min: 0
          max: 128
        doc: Envelope sustain. Defaults to 50
      - id: env_rel
        type: u4
        valid:
          min: 100
          max: 65536
        doc: Envelope release. Defaults to 20000
      - id: env_amt
        type: s4
        valid:
          min: -128
          max: 128
        doc: Envelope amount. Defaults to 0
      - id: lfo_pdly
        type: u4
        valid:
          min: 100
          max: 65536
        doc: LFO predelay. Defaults to minimum
      - id: lfo_att
        type: u4
        valid:
          min: 100
          max: 65536
        doc: LFO attack. Defaults to 20000
      - id: lfo_amt
        type: s4
        valid:
          min: -128
          max: 128
        doc: LFO amount. Defaults to 0
      - id: lfo_spd
        type: u4
        valid:
          min: 200
          max: 65536
        doc: LFO Speed. Defaults to 32950
      - id: lfo_shape
        type: s4
        enum: lfo_shape
      - id: env_att_tns
        type: s4
        valid:
          min: -128
          max: 128
        doc: Envelope attack tension. Defaults to 0
      - id: env_dec_tns
        type: s4
        valid:
          min: -128
          max: 128
        doc: Envelope decay tension. Defaults to 0
      - id: env_rel_tns
        type: s4
        valid:
          min: -128
          max: 128
        doc: Envelope release tension. Defaults to -101
    enums:
      flags:
        0: env_sync
        0b10: lfo_sync
        0b100000: lfo_retrig
      lfo_shape:
        0: sine
        1: tri
        2: pulse
  channel_levels:
    seq:
      - id: pan
        type: u4
        valid:
          min: 0
          max: 12800
        doc: Defaults to 6400
      - id: vol
        type: u4
        valid:
          min: 0
          max: 12800
        doc: Defaults to 10000
      - id: shift
        type: s4
        valid:
          min: -4800
          max: 4800
        doc: Pitch shift (in cents). Defaults to 0
      - id: flt_modx
        type: u4
        valid:
          min: 0
          max: 256
      - id: flt_mody
        type: u4
        valid:
          min: 0
          max: 256
      - id: flt_type
        type: u4
        enum: filter
    enums:
      filter:
        0: fastlp
        1: lp
        2: bp
        3: hp
        4: bs
        5: lpx2
        6: svflp
        7: svflpx2
  channel_lvladj:
    seq:
      - id: pan
        type: s4
      - id: vol
        type: u4
      - size: 4
      - id: mod_x
        type: s4
      - id: mod_y
        type: s4
  channel_polyphony:
    seq:
      - id: max
        type: u4
        valid:
          min: 0
          max: 99
      - id: slide
        type: u4
        valid:
          min: 0
          max: 1660
        doc: Portamento time. Defaults to 820
      - id: flags
        type: u1
        enum: flags
    enums:
      flags:
        0: none
        1: mono
        2: porta
  sampler_reverb:
    seq:
      - id: kind
        type: u2
        enum: kind
      - id: mix
        type: u2
        valid:
          min: 0
          max: 256
    enums:
      kind:
        0: a
        65536: b
  channel_tracking:
    seq:
      - id: mid
        type: u4
        valid:
          min: 0
          max: 131
        doc: Middle note; C0 to B10
      - id: pan
        type: s4
        valid:
          min: -256
          max: 256
      - id: mod_x
        type: s4
        valid:
          min: -256
          max: 256
      - id: mod_y
        type: s4
        valid:
          min: -256
          max: 256
  channel_type:
    seq:
      - id: value
        type: u1
        enum: type
    enums:
      type:
        0: sampler
        2: native
        3: layer
        4: synth
        5: auto
  insert_data:
    seq:
      - size: 4
      - id: flags
        type: u4
        enum: flags
      - size: 4
    enums:
      flags:
        0b0000000000000001: pol_rev
        0b0000000000000010: swaplr
        0b0000000000000100: enablefx
        0b0000000000001000: 'on'
        0b0000000000010000: nomt
        0b0000000001000000: dock_m
        0b0000000010000000: dock_r
        0b0000010000000000: show_sep
        0b0000100000000000: lock
        0b0001000000000000: solo
        0b1000000000000000: audio_track
  insert_routing:
    seq:
      - id: routes
        type: u1
        enum: bool
        repeat: eos
        doc: Map denoting if this insert is routed to the insert at index
  layer_flags:
    seq:
      - id: flags
        type: u4
        enum: flags
    enums:
      flags:
        0: random
        1: xfade
  mixer_blob:
    seq:
      - id: params
        type: param
        repeat: eos
    types:
      param:
        seq:
          - size: 4
          - id: id
            type: u1
            enum: id
          - size: 1
          - id: channel_data
            type: u2
          - id: msg
            type: s4
        enums:
          id:
            0: slot_on
            1: slot_mix
            64: routing
            192: vol
            193: pan
            194: st_sep
            208: lo_gain
            209: mid_gain
            210: hi_gain
            216: lo_freq
            217: mid_freq
            218: hi_freq
            224: lo_q
            225: mid_q
            226: hi_q
  pan_law:
    seq:
      - id: value
        type: u1
        enum: pan_law
    enums:
      pan_law:
        0: circular
        2: triangular
  pattern_ctrls:
    seq:
      - id: ctrls
        type: ctrl
        repeat: eos
    types:
      ctrl:
        seq:
          - id: pos
            type: u4
          - size: 2
          - id: channel_iid
            type: u1
          - id: flags
            type: u1
          - id: value
            type: f4
  pattern_notes:
    seq:
      - id: notes
        type: note
        repeat: eos
    types:
      note:
        seq:
          - id: pos
            type: u4
            doc: Absolute position
          - id: flags
            type: u2
            enum: flags
          - id: channel_iid
            type: u2
            doc: Target channel IID
          - id: len
            type: u4
            doc: Note length or 0 for those from step sequencer
          - id: key
            type: u2
            valid:
              min: 0
              max: 131
          - id: group
            type: u2
            doc: An ID shared by the notes of same group else 0
          - id: fine
            type: u1
            valid:
              min: 0
              max: 240
            doc: Fine pitch. Defaults to 120
          - size: 1
          - id: release
            type: u1
            valid:
              min: 0
              max: 128
            doc: Defaults to 64
          - id: midi_channel
            type: u1
            doc: |
              Denoted by the note color (0 to 15).
              +128 for MIDI dragged into piano roll.
          - id: pan
            type: u1
            valid:
              min: 0
              max: 128
            doc: Defaults to 64
          - id: velocity
            type: u1
            valid:
              min: 0
              max: 128
            doc: Defaults to 100.
          - id: mod_x
            type: u1
            doc: Typically cutoff. Defaults to 128
          - id: mod_y
            type: u1
            doc: Typically cutoff. Defaults to 128
        enums:
          flags:
            0b100: slide
  playlist:
    seq:
      - id: items
        type: item
        repeat: eos
    types:
      item:
        seq:
          - id: pos
            type: u4
          - id: pattern_base
            type: u2
            doc: Always 20480
          - id: idx
            type: u2
          - id: len
            type: u4
          - id: track_riid
            type: u2
            doc: Reversed `track_info::iid`
          - id: group
            type: u2
          - size: 2
          - id: flags
            type: u2
          - size: 4
          - id: start
            type: f4
          - id: end
            type: f4
          - size: 28
            if: (_parent._io.size % 60) == 0
            doc: FL Studio 21+
  plugin_blob:
    seq:
      - id: marker
        type: u4
      - id: state
        type:
          switch-on: marker
          cases:
            8: vst_plugin
            10: vst_plugin
            _: unknown
  sampler_flags:
    seq:
      - id: flags
        type: u4
        enum: flags
    enums:
      flags:
        0b00000001: resample
        0b00000010: regions
        0b00000100: slice_mks
        0b00001000: loop_pts
        0b10000000: on_disk
  sampler_fxflags:
    seq:
      - id: flags
        type: u2
        enum: flags
    enums:
      flags:
        0b00000001: fade_stereo
        0b00000010: reverse
        0b00000100: clip
        0b10000000: swap_stereo
  sampler_rmod:
    seq:
      - id: mix
        type: u2
        valid:
          min: 0
          max: 256
        doc: Defaults to 128
      - id: freq
        type: u2
        valid:
          min: 0
          max: 256
        doc: Defaults to 128
  tempo:
    -webide-representation: '{coarse}.{fine} BPM'
    seq:
      - id: raw
        type: u4
    instances:
      coarse:
        value: raw / 1000
      fine:
        value: raw - coarse
  timestamp:
    seq:
      - id: created_on
        size: 8
      - id: time_spent
        size: 8
  track_info:
    doc-ref: https://tinyurl.com/flstrackoptions
    seq:
      - id: iid
        type: u4
      - id: color
        type: color
      - id: icon
        type: u4
      - id: 'on'
        type: u1
        enum: bool
      - id: height
        type: f4
      - id: lock_h
        type: s4
        doc: Lock to this size
      - id: lock_cnt
        type: u1
        enum: bool
        doc: Lock to content
      - id: motion
        type: u4
        enum: motion
      - id: press
        type: u4
        enum: press
      - id: trig_sync
        type: u4
        enum: sync
      - id: queued
        type: u4
        enum: bool
      - id: tolerant
        type: u4
        enum: bool
      - id: pos_sync
        type: u4
        enum: sync
      - id: grouped
        type: u1
        enum: bool
      - id: locked
        type: u1
        enum: bool
    enums:
      motion:
        0: stay
        1: oneshot
        2: marchwrap
        3: marchstay
        4: marchstop
        5: random
        6: ex_random
      press:
        0: retrig
        1: holdstop
        2: holdmotion
        3: latch
      sync:
        0: 'off'
        1: qbeat
        2: hbeat
        3: beat
        4: x2beat
        5: x4beat
        6: auto
  vst_plugin:
    seq:
      - id: events
        type: event
        repeat: eos
    types:
      event:
        seq:
          - id: type
            type: u4
            enum: id
          - id: len
            type: u8
          - id: data
            size: len
            type:
              switch-on: type
              cases:
                'id::flags': flags
                'id::fourcc': fourcc
                'id::midi': midi
                'id::name': nonulstr
                'id::path': nonulstr
                _: unknown
        enums:
          id:
            1: midi
            2: flags
            30: io
            31: inputs
            32: outputs
            50: info
            51:
              id: fourcc
              doc: Unique VST2 plugin identifier registered with Steinberg
            52:
              id: guid
              doc: 16-byte hexadecimal globally unique identifier
            53:
              id: state
              doc: Plugin preset data
            54:
              id: name
              doc: Plugin name
            55:
              id: path
              doc: Absolute path to the plugin binary
            56:
              id: vendor
              doc: Name of the plugin vendor
            57: unk57
        types:
          nonulstr:
            seq:
              - id: value
                type: str
                size: _parent.len
                encoding: ascii
          fourcc:
            seq:
              - id: value
                type: str
                size: 4
                encoding: ascii
          midi:
            doc-ref: https://tinyurl.com/flswrappersettings, MIDI
            seq:
              - id: input
                type: s4
                valid:
                  min: -1
                  max: 255
                doc: MIDI input port. Defaults to -1
              - id: output
                type: s4
                valid:
                  min: -1
                  max: 255
                doc: MIDI output port. Defaults to -1
              - id: pb_range
                type: u4
                valid:
                  min: 1
                  max: 48
                doc: Pitch bend range. Defaults to 12
          flags:
            seq:
              - size: 9
              - id: flags1
                type: u4
                enum: flags1
              - id: flags2
                type: u4
                enum: flags2
              - size: 5
              - id: fast_idle
                type: u1
                enum: bool
                doc-ref: https://tinyurl.com/flswrappertbs, Fast idle
            enums:
              flags1:
                0b00000000_00000000_00000000_00000001:
                  id: send_pb
                  doc: Send pitch-bend range.
                  doc-ref: https://tinyurl.com/flswrappersettings, MIDI
                0b00000000_00000000_00000000_00000010:
                  id: fixed_buf
                  doc: Use fixed-size buffers.
                  doc-ref: https://tinyurl.com/flswrappertbs
                0b00000000_00000000_00000000_00000100:
                  id: notify_rend
                0b00000000_00000000_00000000_00001000:
                  id: proc_inactive
                  doc: Process inputs and outputs marked as inactive
                  doc-ref: https://tinyurl.com/flswrapperproc
                0b00000000_00000000_00000000_00010000:
                  id: no_rel_vel
                  doc: Don't send relative velocity.
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b00000000_00000000_00000000_00100000:
                  id: no_send_change
                  doc: Don't notify of changes
                  doc-ref: https://tinyurl.com/flswrapperproc
                0b00000000_00000000_00000100_00000000:
                  id: send_loop
                  doc: Let the plugin know about loop start and end points
                  doc-ref: https://tinyurl.com/flswrappertbs
                0b00000000_00000000_00001000_00000000:
                  id: allow_tp
                  doc: Allow threaded processing
                  doc-ref: https://tinyurl.com/flswrapperproc
                0b00000000_00000000_01000000_00000000:
                  id: keep_focus
                  doc: Prevent the plugin from stealing keyboard input
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b00000000_00000000_10000000_00000000:
                  id: no_cpu_state
                  doc: Ensure processor state in between callbacks
                  doc-ref: https://tinyurl.com/flswrapperproc
                0b00000000_00000001_00000000_00000000:
                  id: send_modx
                  doc: Send MOD X as polyphonic aftertouch
                  doc-ref: https://tinyurl.com/flswrappersettings, MIDI
                0b00000000_00000010_00000000_00000000:
                  id: bridge_plugin
                  doc: Load plugin in a briged process
                  doc-ref: https://tinyurl.com/flswrapperproc, Make bridged
                0b00000000_00010000_00000000_00000000:
                  id: bridge_editor
                  doc: Keep plugin editor in a bridge process
                  doc-ref: https://tinyurl.com/flswrapperproc, External window
                0b00000000_01000000_00000000_00000000:
                  id: upd_hidden
                  doc: Update plugin UI even when it's hidden
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b00000001_00000000_00000000_00000000:
                  id: no_reset
                0b00000010_00000000_00000000_00000000:
                  id: dpi_aware
                  doc: DPI aware when bridged
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b00001000_00000000_00000000_00000000:
                  id: file_drop
                  doc: Accept dropped files
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b00010000_00000000_00000000_00000000:
                  id: allow_sd
                  doc: Allow smart disable
                  doc-ref: https://tinyurl.com/flswrapperproc
                0b00100000_00000000_00000000_00000000:
                  id: scale_ui
                  doc: Scale editor dimensions
                  doc-ref: https://tinyurl.com/flswrappersettings, GUI
                0b01000000_00000000_00000000_00000000:
                  id: no_time_ofs
                  doc: Adjust time information reported to a plugin
                  doc-ref: https://tinyurl.com/flswrappertbs, Use time offset
              flags2:
                0:
                  id: proc_max_size
                  doc: Process maximum size buffers
                  doc-ref: https://tinyurl.com/flswrappertbs
                1:
                  id: host_max
                  doc: Use maximum buffer size from host
                  doc-ref: https://tinyurl.com/flswrappertbs
  version:
    -webide-representation: 'v{major}.{minor}.{patch}.{build}'
    seq:
      - id: parts
        type: str
        encoding: ascii
        terminator: 0x2e
        repeat: eos
        eos-error: false
    instances:
      major:
        value: parts[0].to_i
      minor:
        value: parts[1].to_i
      patch:
        value: parts[2].to_i
      build:
        value: parts[3].to_i
  wrapper:
    seq:
      - size: 16
      - id: flags
        type: u2
        enum: flags
      - size: 2
      - id: page
        type: u1
        enum: page
        doc: Currently selected page
        doc-ref: https://tinyurl.com/flswrapperpage
      - size: 23
      - id: width
        type: u4
        doc: Plugin editor width (in px)
      - id: height
        type: u4
        doc: Plugin editor height (in px)
    enums:
      flags:
        0b00000000_00000001: visible
        0b00000000_00000010:
          id: disabled
          doc: Deprecated by `id::channel_on`, `mixer_blob::param::id::slot_on`
        0b00000000_00000100: detached
        0b00000000_00010000: generator
        0b00000000_00100000: smart_disable
        0b00000000_01000000: threaded
        0b00000000_10000000:
          id: demo
          doc: Plugin is in demo / trial mode. VST3 deprecated this flag.
        0b00000001_00000000: hide_settings
        0b00000010_00000000: minimized
        0b10000000_00000000:
          id: directx
          doc: Used as a marker for (now unsupported) DirectX plugins.
      page:
        0: editor
        1: settings
        3: sample
        4: envlfo
        5: misc
