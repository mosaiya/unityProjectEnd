using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class mis1_2 : MonoBehaviour
{
    float i = 10f;
    float j = -40f;
    public GameObject item;
    // Start is called before the first frame update
    void OnMouseDown()
    {
        transform.Rotate(0, j, 0);
        item.transform.Rotate(0, i, 0);

    }
}
