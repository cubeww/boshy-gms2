function prehistorik_chest_pose_step(_player, _age) {
    _player.chest_pose_age = _age;
    if (_age <= 0) {
        _player.chest_pose_clip = undefined;
        _player.chest_pose_units = 0;
        return;
    }
    if (struct_exists(_player.character, "custom")) {
        return;
    }

    var _clip = prehistorik_chest_clip(_player, _age >= 250);
    if (is_undefined(_player.chest_pose_clip) || _player.chest_pose_clip != _clip) {
        // Fusion's Force Animation changes the pose without advancing that tick.
        _player.chest_pose_clip = _clip;
        _player.chest_pose_units = 0;
    } else if (_age <= 200 || _age > 250) {
        // The native animation advances before STOPANIM at 200 and resumes after 250.
        _player.chest_pose_units += round(_clip.speed * delta_time / 20000);
    }
}

function prehistorik_draw_chest_pose(_player) {
    var _age = _player.chest_pose_age;
    if (_age == 0) {
        // The collision starts the timer. The opening pose is forced on the next step.
        with (_player) {
            event_perform(ev_draw, 0);
        }
        return;
    }
    var _reveal = _age >= 250;
    if (struct_exists(_player.character, "custom")) {
        var _pose = _reveal ? CustomPose.ItemGet : CustomPose.OpenChest;
        // The Picture extension keeps its own frame counter while stock actors are stopped.
        var _steps = _reveal ? _age - 250 : _age - 1;
        var _frame = custom_character_frame_at(_player.character.custom.animations[_pose], _steps);
        game_character_draw(_player.character, _pose, _frame, _player.visual_facing(), _player.x, _player.y);
        return;
    }
    // Original frame 2 animations 12 and 13. Atlas entries use the native image handles.
    // Each frame stores its atlas rectangle and cropped source hotspot.
    static _frames = {
        f2499: [347, 391, 16, 18, 8, 17],
        f2512: [365, 391, 16, 18, 8, 17],
        f2517: [489, 317, 18, 23, 9, 22],
        f2518: [477, 343, 17, 21, 8, 20],
        f2519: [1, 343, 18, 23, 8, 22],
        f2525: [19, 413, 16, 17, 8, 16],
        f2529: [1, 368, 17, 21, 9, 20],
        f2560: [327, 433, 14, 16, 6, 15],
        f2593: [115, 451, 14, 15, 6, 14],
        f2614: [244, 256, 21, 28, 8, 23],
        f2615: [131, 451, 14, 15, 7, 14],
        f2676: [344, 290, 16, 24, 9, 21],
        f2677: [362, 290, 16, 24, 9, 21],
        f2855: [380, 290, 16, 24, 9, 21],
        f2858: [398, 290, 16, 24, 9, 21],
        f2871: [120, 256, 26, 30, 10, 23],
        f2873: [148, 256, 26, 30, 15, 23],
        f2874: [177, 343, 16, 22, 10, 17],
        f2875: [195, 343, 16, 22, 9, 17],
        f2876: [213, 343, 16, 22, 10, 17],
        f2877: [231, 343, 16, 22, 9, 17],
        f2880: [132, 368, 15, 21, 7, 21],
        f2881: [149, 368, 15, 21, 7, 21],
        f2906: [61, 343, 16, 23, 9, 18],
        f2907: [79, 343, 16, 23, 9, 18],
        f2908: [81, 433, 16, 16, 9, 15],
        f3467: [290, 256, 18, 26, 9, 25],
        f4452: [416, 290, 16, 24, 7, 23],
        f4453: [434, 290, 16, 24, 8, 23],
        f4454: [452, 290, 16, 24, 7, 23],
        f4455: [470, 290, 16, 24, 7, 23],
        f4456: [488, 290, 16, 24, 7, 23],
        f4465: [349, 451, 16, 13, 5, 12],
        f4466: [367, 451, 16, 13, 10, 12],
        f4467: [261, 451, 16, 14, 9, 13],
        f4468: [279, 451, 16, 14, 9, 13],
        f4469: [297, 451, 16, 14, 6, 13],
        f4470: [315, 451, 16, 14, 6, 13],
        f4478: [357, 317, 20, 23, 7, 22],
        f4484: [173, 317, 21, 23, 7, 22],
        f4485: [379, 317, 20, 23, 7, 22],
        f4486: [196, 317, 21, 23, 13, 22],
        f4564: [147, 451, 14, 15, 6, 14],
        f4565: [163, 451, 14, 15, 7, 14],
        f4581: [333, 451, 14, 14, 7, 11],
        f4582: [225, 433, 15, 16, 7, 12],
        f4583: [239, 451, 20, 14, 10, 11],
        f4584: [242, 433, 15, 16, 7, 12],
        f4586: [99, 433, 16, 16, 8, 13],
        f4598: [21, 343, 18, 23, 9, 22],
        f4599: [41, 343, 18, 23, 8, 22],
        f4601: [310, 256, 18, 26, 8, 25],
        f4626: [96, 368, 16, 21, 7, 20],
        f4627: [114, 368, 16, 21, 7, 20],
        f4628: [391, 343, 21, 21, 10, 20],
        f4629: [414, 343, 21, 21, 10, 20],
        f4637: [343, 433, 14, 16, 9, 13],
        f4640: [359, 433, 14, 16, 7, 13],
        f4641: [179, 451, 13, 15, 7, 14],
        f4642: [194, 451, 13, 15, 6, 14],
        f4643: [43, 433, 17, 16, 6, 14],
        f4644: [62, 433, 17, 16, 10, 14],
        f4661: [43, 451, 16, 15, 8, 14],
        f4662: [259, 433, 15, 16, 8, 15],
        f4663: [276, 433, 15, 16, 6, 14],
        f4664: [293, 433, 15, 16, 8, 15],
        f4665: [61, 451, 16, 15, 8, 14],
        f4666: [79, 451, 16, 15, 8, 14],
        f4667: [310, 433, 15, 16, 6, 14],
        f4668: [97, 451, 16, 15, 8, 14],
        f4669: [117, 433, 16, 16, 9, 15],
        f4671: [135, 433, 16, 16, 6, 15],
        f4674: [471, 433, 12, 16, 5, 15],
        f4676: [485, 433, 12, 16, 5, 15],
        f4677: [499, 433, 12, 16, 5, 15],
        f4678: [1, 451, 12, 16, 5, 15],
        f4679: [375, 433, 14, 16, 6, 15],
        f4681: [391, 433, 14, 16, 6, 15],
        f4683: [153, 433, 16, 16, 7, 15],
        f4686: [171, 433, 16, 16, 7, 15],
        f4689: [189, 433, 16, 16, 7, 15],
        f4692: [207, 433, 16, 16, 7, 15],
        f4695: [383, 391, 16, 18, 7, 16],
        f4696: [37, 413, 16, 17, 7, 15],
        f4697: [401, 391, 16, 18, 7, 16],
        f4698: [55, 413, 16, 17, 7, 15],
        f4699: [73, 413, 16, 17, 7, 15],
        f4700: [91, 413, 16, 17, 7, 15],
        f4701: [109, 413, 16, 17, 7, 15],
        f4702: [419, 391, 16, 18, 7, 16],
        f4703: [127, 413, 16, 17, 7, 15],
        f4704: [145, 413, 16, 17, 7, 15],
        f4705: [437, 391, 16, 18, 7, 16],
        f4706: [163, 413, 16, 17, 7, 15],
        f4712: [455, 391, 16, 18, 7, 16],
        f4720: [473, 391, 16, 18, 7, 16],
        f4744: [267, 256, 21, 28, 12, 23],
        f5226: [218, 256, 24, 28, 12, 27],
        f5251: [181, 413, 16, 17, 8, 16],
        f5254: [491, 391, 16, 18, 8, 17],
        f5258: [1, 413, 16, 18, 8, 17],
        f5426: [299, 215, 24, 37, 13, 36],
        f5427: [176, 256, 40, 28, 19, 19],
        f5428: [351, 215, 29, 36, 18, 35],
        f5538: [15, 451, 12, 16, 5, 15],
        f5539: [29, 451, 12, 16, 5, 15],
        f5540: [99, 290, 21, 24, 10, 23],
        f5577: [309, 391, 17, 19, 7, 18],
        f5581: [328, 391, 17, 19, 9, 18],
        f5583: [467, 413, 20, 16, 9, 15],
        f5586: [489, 413, 20, 16, 10, 15],
        f5622: [168, 290, 20, 24, 10, 23],
        f5628: [190, 290, 20, 24, 10, 23],
        f5631: [376, 256, 20, 25, 10, 24],
        f5639: [1, 290, 15, 25, 7, 24],
        f5648: [212, 290, 20, 24, 10, 23],
        f5649: [234, 290, 20, 24, 10, 23],
        f5650: [398, 256, 20, 25, 10, 24],
        f5651: [420, 256, 20, 25, 10, 24],
        f5652: [442, 256, 20, 25, 10, 24],
        f5653: [464, 256, 20, 25, 10, 24],
        f5654: [256, 290, 20, 24, 10, 23],
        f5655: [278, 290, 20, 24, 10, 23],
        f5656: [486, 256, 20, 25, 10, 24],
        f5664: [122, 290, 21, 24, 15, 23],
        f5665: [330, 256, 21, 25, 15, 17],
        f5669: [300, 290, 20, 24, 9, 23],
        f5670: [322, 290, 20, 24, 10, 23],
        f5674: [199, 413, 16, 17, 8, 16],
        f5722: [271, 413, 15, 17, 6, 17],
        f5723: [145, 290, 21, 24, 5, 23],
        f5724: [288, 413, 15, 17, 8, 17],
        f5725: [18, 290, 15, 25, 7, 24],
        f5726: [353, 256, 21, 25, 5, 17],
        f5731: [249, 343, 16, 22, 8, 21],
        f5735: [267, 343, 16, 22, 7, 21],
        f5736: [37, 317, 12, 24, 6, 23],
        f5738: [357, 343, 15, 22, 7, 21],
        f5739: [1, 317, 16, 24, 7, 23],
        f5740: [374, 343, 15, 22, 7, 21],
        f5741: [51, 317, 12, 24, 5, 23],
        f5761: [19, 317, 16, 24, 8, 23],
        f5801: [390, 368, 34, 20, 16, 20],
        f5802: [166, 368, 36, 20, 16, 19],
        f5803: [1, 433, 19, 16, 9, 15],
        f5804: [22, 433, 19, 16, 9, 15],
        f5808: [242, 368, 35, 20, 17, 20],
        f5809: [279, 368, 35, 20, 17, 19],
        f5810: [426, 368, 34, 20, 16, 19],
        f5811: [462, 368, 34, 20, 17, 20],
        f5812: [316, 368, 35, 20, 17, 20],
        f5813: [353, 368, 35, 20, 17, 19],
        f5814: [1, 391, 34, 20, 17, 19],
        f5822: [204, 368, 36, 20, 19, 19],
        f5853: [401, 317, 20, 23, 11, 22],
        f5855: [423, 317, 20, 23, 8, 22],
        f5864: [37, 391, 23, 20, 10, 19],
        f5865: [62, 391, 23, 20, 9, 19],
        f5866: [445, 317, 20, 23, 8, 20],
        f5867: [87, 391, 23, 20, 13, 19],
        f5886: [467, 317, 20, 23, 11, 20],
        f5887: [112, 391, 23, 20, 12, 19],
        f5905: [305, 413, 15, 17, 7, 16],
        f5906: [339, 413, 14, 17, 6, 16],
        f5907: [407, 433, 14, 16, 6, 15],
        f5908: [423, 433, 14, 16, 6, 15],
        f5909: [355, 413, 14, 17, 6, 16],
        f5910: [371, 413, 14, 17, 6, 16],
        f5911: [387, 413, 14, 17, 6, 16],
        f5912: [217, 413, 16, 17, 7, 16],
        f5913: [322, 413, 15, 17, 7, 16],
        f5914: [403, 413, 14, 17, 7, 16],
        f5915: [439, 433, 14, 16, 7, 15],
        f5916: [419, 413, 14, 17, 7, 16],
        f5917: [455, 433, 14, 16, 7, 15],
        f5918: [435, 413, 14, 17, 7, 16],
        f5919: [451, 413, 14, 17, 7, 16],
        f5921: [235, 413, 16, 17, 8, 16],
        f5922: [253, 413, 16, 17, 8, 16],
        f5930: [219, 317, 21, 23, 12, 22],
        f5932: [242, 317, 21, 23, 8, 22],
        f6046: [265, 317, 21, 23, 9, 21],
        f6047: [288, 317, 21, 23, 11, 21],
        f6049: [311, 317, 21, 23, 9, 21],
        f6050: [137, 391, 23, 20, 10, 20],
        f6051: [162, 391, 23, 20, 12, 20],
        f6052: [97, 343, 18, 22, 8, 20],
        f6053: [334, 317, 21, 23, 11, 21],
        f6054: [117, 343, 18, 22, 9, 20],
        f6055: [65, 317, 25, 23, 13, 19],
        f6057: [92, 317, 25, 23, 13, 19],
        f6058: [119, 317, 25, 23, 11, 19],
        f6059: [146, 317, 25, 23, 11, 19],
        f6078: [437, 343, 18, 21, 7, 20],
        f6079: [137, 343, 18, 22, 7, 21],
        f6080: [20, 368, 17, 21, 5, 20],
        f6081: [285, 343, 16, 22, 5, 21],
        f6082: [303, 343, 16, 22, 5, 21],
        f6083: [157, 343, 18, 22, 10, 21],
        f6084: [457, 343, 18, 21, 10, 20],
        f6085: [321, 343, 16, 22, 10, 21],
        f6086: [339, 343, 16, 22, 10, 21],
        f6087: [39, 368, 17, 21, 11, 20],
        f6088: [58, 368, 17, 21, 7, 20],
        f6089: [77, 368, 17, 21, 9, 20],
        f6121: [247, 391, 29, 19, 15, 18],
        f6122: [35, 290, 30, 24, 15, 23],
        f6123: [487, 215, 21, 32, 10, 31],
        f6125: [70, 256, 23, 31, 11, 30],
        f6126: [1, 256, 21, 32, 10, 31],
        f6128: [278, 391, 29, 19, 13, 18],
        f6129: [67, 290, 30, 24, 14, 23],
        f6130: [24, 256, 21, 32, 10, 31],
        f6131: [95, 256, 23, 31, 11, 30],
        f6132: [47, 256, 21, 32, 10, 31],
        f6170: [297, 1, 64, 57, 18, 52],
        f6171: [54, 115, 41, 55, 19, 51],
        f6172: [97, 115, 41, 55, 21, 51],
        f6173: [363, 1, 64, 57, 45, 52],
        f6207: [195, 1, 32, 83, 14, 80],
        f6208: [229, 1, 32, 83, 14, 80],
        f6209: [263, 1, 32, 83, 14, 80],
        f6210: [161, 1, 32, 84, 14, 81],
        f6576: [340, 173, 22, 39, 10, 37],
        f6577: [364, 173, 22, 39, 10, 37],
        f6578: [388, 173, 22, 39, 10, 37],
        f6579: [412, 173, 22, 39, 10, 37],
        f6580: [436, 173, 22, 39, 10, 37],
        f6581: [460, 173, 22, 39, 10, 37],
        f6582: [484, 173, 22, 39, 10, 37],
        f6583: [1, 215, 22, 39, 10, 37],
        f6584: [25, 215, 22, 39, 10, 37],
        f6585: [49, 215, 22, 39, 10, 37],
        f6586: [73, 215, 22, 39, 10, 37],
        f6587: [97, 215, 22, 39, 10, 37],
        f6588: [121, 215, 22, 39, 10, 37],
        f6589: [145, 215, 22, 39, 10, 37],
        f6590: [169, 215, 22, 39, 10, 37],
        f6591: [193, 215, 22, 39, 10, 37],
        f6592: [217, 215, 22, 39, 10, 37],
        f6593: [194, 115, 24, 42, 11, 41],
        f6594: [272, 215, 25, 38, 12, 37],
        f6595: [382, 215, 25, 36, 12, 35],
        f6596: [435, 215, 24, 35, 12, 34],
        f6597: [325, 215, 24, 37, 10, 36],
        f6598: [461, 215, 24, 35, 12, 34],
        f6599: [409, 215, 24, 36, 11, 35],
        f6600: [1, 173, 25, 40, 11, 39],
        f6601: [251, 115, 26, 41, 12, 40],
        f6602: [333, 115, 30, 40, 14, 39],
        f6603: [220, 115, 29, 41, 13, 40],
        f6604: [365, 115, 30, 40, 13, 39],
        f6605: [397, 115, 29, 40, 12, 39],
        f6606: [428, 115, 29, 40, 13, 39],
        f6607: [124, 173, 29, 39, 13, 38],
        f6608: [155, 173, 29, 39, 13, 38],
        f6609: [186, 173, 29, 39, 13, 38],
        f6610: [217, 173, 29, 39, 13, 38],
        f6611: [28, 173, 30, 39, 13, 38],
        f6612: [60, 173, 30, 39, 13, 38],
        f6613: [92, 173, 30, 39, 13, 38],
        f6614: [248, 173, 29, 39, 13, 38],
        f6615: [241, 215, 29, 38, 13, 37],
        f6616: [279, 173, 29, 39, 13, 38],
        f6617: [310, 173, 28, 39, 13, 38],
        f6618: [459, 115, 28, 40, 13, 39],
        f6619: [140, 115, 25, 42, 11, 41],
        f6620: [279, 115, 26, 41, 12, 40],
        f6621: [167, 115, 25, 42, 12, 41],
        f6623: [307, 115, 24, 41, 11, 40],
        f6641: [209, 451, 13, 15, 5, 14],
        f6646: [224, 451, 13, 15, 7, 14],
        f6648: [385, 451, 16, 8, 7, 7],
        f6649: [403, 451, 16, 8, 8, 7],
        f6745: [187, 391, 18, 20, 9, 19],
        f6748: [207, 391, 18, 20, 8, 19],
        f6749: [227, 391, 18, 20, 8, 19],
        f6775: [429, 1, 51, 56, 18, 55],
        f6776: [1, 115, 51, 56, 24, 55],
        f6778: [1, 1, 38, 112, 16, 111],
        f6779: [41, 1, 38, 112, 16, 111],
        f6781: [81, 1, 38, 112, 16, 111],
        f6782: [121, 1, 38, 112, 16, 111],
        f71: [1, 469, 32, 32, 0, 0],
        f123: [35, 469, 18, 18, 8, 17],
        f588: [55, 469, 18, 19, 8, 18],
        f1560: [75, 469, 22, 21, 10, 20],
        f1565: [99, 469, 23, 21, 11, 20],
        f1566: [124, 469, 24, 21, 12, 20],
        f1567: [150, 469, 23, 20, 11, 19],
        f1568: [175, 469, 22, 21, 11, 20],
        f1569: [199, 469, 23, 21, 11, 20],
        f1586: [224, 469, 24, 21, 11, 20],
        f1587: [250, 469, 23, 20, 11, 19],
        f1622: [275, 469, 16, 22, 7, 21],
        f1623: [293, 469, 16, 21, 7, 20],
        f1624: [311, 469, 16, 23, 7, 22],
        f1625: [329, 469, 16, 23, 7, 22],
        f1626: [347, 469, 16, 23, 7, 22],
        f1627: [365, 469, 17, 23, 8, 22],
        f1628: [384, 469, 16, 21, 8, 20],
        f1629: [402, 469, 16, 22, 8, 21],
        f1630: [420, 469, 16, 23, 8, 22],
        f1631: [438, 469, 16, 23, 8, 22],
        f1632: [456, 469, 16, 23, 8, 22],
        f1633: [474, 469, 17, 23, 8, 22],
        f1679: [1, 503, 20, 23, 7, 22],
        f1680: [23, 503, 20, 23, 12, 22],
        f2439: [45, 503, 13, 16, 6, 15],
        f2444: [60, 503, 13, 16, 6, 15],
        f6786: [75, 503, 18, 20, 8, 19],
        f6793: [95, 503, 18, 20, 9, 19]
    };
    var _clip = _player.chest_pose_clip;
    var _frame_index = max(0, (_player.chest_pose_units - 1) div 100);
    var _count = array_length(_clip.frames);
    if (_frame_index >= _count) {
        if (_clip.loop) {
            _frame_index = _clip.loop_start + (_frame_index - _count) mod (_count - _clip.loop_start);
        } else {
            _frame_index = _count - 1;
        }
    }
    var _frame = struct_get(_frames, _clip.frames[_frame_index]);
    draw_sprite_part_ext(spr_prehistorik_chest_poses, 0, _frame[0], _frame[1], _frame[2], _frame[3],
        _player.x - _frame[4], _player.y - _frame[5], 1, 1, c_white, 1);
}

function prehistorik_chest_clip(_player, _reveal) {
    // Opening right/left, then item-get right/left, keyed by License/Character ID.
    static _clips = {
        c12: [
            { frames: ["f2499", "f2525"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2499", "f2525"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2512"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2512"], speed: 50, loop: true, loop_start: 0 }
        ],
        c16: [
            { frames: ["f4626", "f4627"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4626", "f4627"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4628"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4629"], speed: 50, loop: true, loop_start: 0 }
        ],
        c20: [
            { frames: ["f4581", "f4582", "f4583", "f4584"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4581", "f4582", "f4583", "f4584"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4586"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4586"], speed: 50, loop: true, loop_start: 0 }
        ],
        c24: [
            { frames: ["f2529", "f2518"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2529", "f2518"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2519"], speed: 49, loop: true, loop_start: 0 },
            { frames: ["f2517"], speed: 50, loop: true, loop_start: 0 }
        ],
        c28: [
            { frames: ["f4478", "f4485"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4478", "f4485"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4484"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4486"], speed: 50, loop: true, loop_start: 0 }
        ],
        c32: [
            { frames: ["f4640", "f4641", "f4637", "f4642"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4640", "f4641", "f4637", "f4642"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4644"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4643"], speed: 50, loop: true, loop_start: 0 }
        ],
        c36: [
            { frames: ["f2560", "f2593", "f2560", "f2615"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2560", "f2593", "f2560", "f2615"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4564"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4565"], speed: 50, loop: true, loop_start: 0 }
        ],
        c40: [
            { frames: ["f4683", "f4696", "f4697", "f4698", "f4686", "f4699", "f4695", "f4700"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f4689", "f4701", "f4702", "f4704", "f4692", "f4703", "f4705", "f4706"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4712"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4720"], speed: 50, loop: true, loop_start: 0 }
        ],
        c44: [
            { frames: ["f4664", "f4666", "f4667", "f4668"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f4662", "f4661", "f4663", "f4665"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4669"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4671"], speed: 50, loop: true, loop_start: 0 }
        ],
        c48: [
            { frames: ["f4674", "f4676"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f4677", "f4678"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4681"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4679"], speed: 50, loop: true, loop_start: 0 }
        ],
        c52: [
            { frames: ["f4599", "f4598"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4599", "f4598"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f3467"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4601"], speed: 50, loop: true, loop_start: 0 }
        ],
        c56: [
            { frames: ["f4467", "f4468"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4469", "f4470"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4465"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4466"], speed: 50, loop: true, loop_start: 0 }
        ],
        c60: [
            { frames: ["f4454", "f4456"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4454", "f4452"], speed: 40, loop: true, loop_start: 0 },
            { frames: ["f4455"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f4453"], speed: 50, loop: true, loop_start: 0 }
        ],
        c64: [
            { frames: ["f2614", "f4744"], speed: 90, loop: true, loop_start: 0 },
            { frames: ["f2614", "f4744"], speed: 90, loop: true, loop_start: 0 },
            { frames: ["f4744"], speed: 15, loop: true, loop_start: 0 },
            { frames: ["f2614"], speed: 15, loop: true, loop_start: 0 }
        ],
        c68: [
            { frames: ["f2875", "f2876"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f2877", "f2874"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f2873"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2871"], speed: 50, loop: true, loop_start: 0 }
        ],
        c72: [
            { frames: ["f2855", "f2858"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f2676", "f2677"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f2880"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2881"], speed: 50, loop: true, loop_start: 0 }
        ],
        c76: [
            { frames: ["f2906", "f2907"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2906", "f2907"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2908"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f2908"], speed: 50, loop: true, loop_start: 0 }
        ],
        c80: [
            { frames: ["f5226"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5226"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5226"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5226"], speed: 50, loop: true, loop_start: 0 }
        ],
        c84: [
            { frames: ["f5254", "f5251"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5254", "f5251"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5258"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5258"], speed: 50, loop: true, loop_start: 0 }
        ],
        c88: [
            { frames: ["f5426", "f5428"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5426", "f5428"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5427"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5427"], speed: 50, loop: true, loop_start: 0 }
        ],
        c92: [
            { frames: ["f5539", "f5538"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5539", "f5538"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5540"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5540"], speed: 50, loop: true, loop_start: 0 }
        ],
        c96: [
            { frames: ["f5583", "f5804"], speed: 20, loop: true, loop_start: 0 },
            { frames: ["f5586", "f5803"], speed: 20, loop: true, loop_start: 0 },
            { frames: ["f5581"], speed: 20, loop: true, loop_start: 0 },
            { frames: ["f5577"], speed: 20, loop: true, loop_start: 0 }
        ],
        c100: [
            { frames: ["f5674", "f5905", "f5906", "f5908", "f5907", "f5910", "f5909", "f5911"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5912", "f5913", "f5914", "f5915", "f5917", "f5916", "f5919", "f5918"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f5922", "f5922"], speed: 40, loop: false, loop_start: 0 },
            { frames: ["f5921", "f5921"], speed: 40, loop: false, loop_start: 0 }
        ],
        c104: [
            { frames: ["f5622", "f5653", "f5654", "f5652", "f5655", "f5656"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f5628", "f5631", "f5648", "f5650", "f5649", "f5651"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f5669"], speed: 40, loop: false, loop_start: 0 },
            { frames: ["f5670"], speed: 40, loop: false, loop_start: 0 }
        ],
        c108: [
            { frames: ["f5725", "f5723", "f5726"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5639", "f5664", "f5665"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5722"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f5724"], speed: 50, loop: false, loop_start: 0 }
        ],
        c112: [
            { frames: ["f5735", "f5741", "f5740", "f5741"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f5731", "f5736", "f5738", "f5736"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f5739"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f5761"], speed: 25, loop: true, loop_start: 0 }
        ],
        c116: [
            { frames: ["f5811", "f5812", "f5813", "f5814", "f5822"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f5801", "f5808", "f5809", "f5810", "f5802"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f5811", "f5812", "f5813", "f5814", "f5822"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f5801", "f5808", "f5809", "f5810", "f5802"], speed: 50, loop: false, loop_start: 0 }
        ],
        c120: [
            { frames: ["f5855", "f5865", "f5866", "f5864"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5853", "f5867", "f5886", "f5887"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5932"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f5930"], speed: 50, loop: true, loop_start: 0 }
        ],
        c124: [
            { frames: ["f6046", "f6050", "f6049", "f6052"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6047", "f6051", "f6053", "f6054"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6058", "f6057"], speed: 30, loop: true, loop_start: 1 },
            { frames: ["f6055", "f6059"], speed: 30, loop: true, loop_start: 1 }
        ],
        c128: [
            { frames: ["f6079", "f6078", "f6081", "f6082", "f6080", "f6081"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6083", "f6084", "f6085", "f6086", "f6087", "f6085"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6088"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6089"], speed: 25, loop: true, loop_start: 0 }
        ],
        c132: [
            { frames: ["f6128", "f6129"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6121", "f6122"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6130", "f6131", "f6132", "f6131"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6123", "f6125", "f6126", "f6125"], speed: 25, loop: true, loop_start: 0 }
        ],
        c136: [
            { frames: ["f6171", "f6170"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6172", "f6173"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6207", "f6209", "f6208", "f6210", "f6208", "f6209"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6207", "f6209", "f6208", "f6210", "f6208", "f6209"], speed: 25, loop: true, loop_start: 0 }
        ],
        c140: [
            { frames: ["f6646"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6641"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6649"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6648"], speed: 25, loop: true, loop_start: 0 }
        ],
        c144: [
            { frames: ["f6576", "f6577", "f6578", "f6579", "f6580", "f6581", "f6582", "f6583", "f6584", "f6585", "f6586", "f6587", "f6588", "f6589", "f6590", "f6591", "f6592"], speed: 70, loop: true, loop_start: 0 },
            { frames: ["f6576", "f6577", "f6578", "f6579", "f6580", "f6581", "f6582", "f6583", "f6584", "f6585", "f6586", "f6587", "f6588", "f6589", "f6590", "f6591", "f6592"], speed: 70, loop: true, loop_start: 0 },
            { frames: ["f6593", "f6594", "f6595", "f6596", "f6598", "f6599", "f6597", "f6600", "f6601", "f6603", "f6602", "f6604", "f6605", "f6606", "f6607", "f6608", "f6609", "f6610", "f6611", "f6612", "f6613", "f6614", "f6615", "f6616", "f6617", "f6618", "f6620", "f6619", "f6621", "f6623"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6593", "f6594", "f6595", "f6596", "f6598", "f6599", "f6597", "f6600", "f6601", "f6603", "f6602", "f6604", "f6605", "f6606", "f6607", "f6608", "f6609", "f6610", "f6611", "f6612", "f6613", "f6614", "f6615", "f6616", "f6617", "f6618", "f6620", "f6619", "f6621", "f6623"], speed: 25, loop: true, loop_start: 0 }
        ],
        c148: [
            { frames: ["f6775", "f6776"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6775", "f6776"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6778", "f6781", "f6782", "f6779"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6778", "f6781", "f6782", "f6779"], speed: 25, loop: true, loop_start: 0 }
        ],
        c152: [
            { frames: ["f6749"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6745"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6748"], speed: 25, loop: true, loop_start: 0 },
            { frames: ["f6745"], speed: 25, loop: true, loop_start: 0 }
        ]
    };

    // Frames 6 and 53 use Player 574 and earlier clones of the first five stock costumes.
    // The clones without animations 12/13 resolve both requests to their idle clip.
    static _boss_clips = {
        c12: [
            { frames: ["f588"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f588"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f123"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f123"], speed: 50, loop: false, loop_start: 0 }
        ],
        c16: [
            { frames: ["f1560", "f1565", "f1566", "f1567"], speed: 30, loop: true, loop_start: 0 },
            { frames: ["f1568", "f1569", "f1586", "f1587"], speed: 30, loop: true, loop_start: 0 }
        ],
        c20: [
            { frames: ["f71"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f71"], speed: 50, loop: false, loop_start: 0 }
        ],
        c24: [
            { frames: ["f1628", "f1629", "f1630", "f1631", "f1632", "f1633", "f1632", "f1629", "f1628"],
                speed: 25, loop: true, loop_start: 0 },
            { frames: ["f1623", "f1622", "f1624", "f1625", "f1626", "f1627", "f1626", "f1622", "f1623"],
                speed: 25, loop: true, loop_start: 0 }
        ],
        c28: [
            { frames: ["f1679"], speed: 50, loop: true, loop_start: 0 },
            { frames: ["f1680"], speed: 50, loop: true, loop_start: 0 }
        ],
        c32: [
            { frames: ["f2444"], speed: 50, loop: false, loop_start: 0 },
            { frames: ["f2439"], speed: 50, loop: false, loop_start: 0 }
        ]
    };
    static _unarmored = [
        { frames: ["f6786"], speed: 25, loop: true, loop_start: 0 },
        { frames: ["f6793"], speed: 25, loop: true, loop_start: 0 }
    ];
    static _meat_boy_open = [
        { frames: ["f5583"], speed: 20, loop: true, loop_start: 0 },
        { frames: ["f5586"], speed: 20, loop: true, loop_start: 0 }
    ];

    var _direction = _player.facing < 0 ? 1 : 0;
    if (_player.arthur_armor_lost) {
        return _unarmored[_direction];
    }
    var _character_id = global.profile.character_id;
    if (_character_id == 96 && room != rm_prehistorik && !_reveal) {
        return _meat_boy_open[_direction];
    }
    var _key = "c" + string(_character_id);
    var _character_clips = (room == rm_ryu || room == rm_cheetah_men) ? struct_get(_boss_clips, _key) : undefined;
    if (is_undefined(_character_clips)) {
        _character_clips = struct_get(_clips, _key);
    }
    if (is_undefined(_character_clips)) {
        _character_clips = _clips.c12;
    }
    var _slot = _reveal && array_length(_character_clips) == 4 ? 2 : 0;
    return _character_clips[_slot + _direction];
}
