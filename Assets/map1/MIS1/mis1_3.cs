﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mis1_3 : MonoBehaviour
{
    float i = 20f;
    float j = -5f;
    public GameObject item;
    // Start is called before the first frame update
    void OnMouseDown()
    {
        transform.Rotate(0, j, 0);
        item.transform.Rotate(0, i, 0);

    }
}
