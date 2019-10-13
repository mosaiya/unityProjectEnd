using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mis1_4 : MonoBehaviour
{
    float i = 160f;
    float j = -20f;
    public GameObject item;
    // Start is called before the first frame update
    void OnMouseDown()
    {
        transform.Rotate(0, j, 0);
        item.transform.Rotate(0, i, 0);

    }
}
