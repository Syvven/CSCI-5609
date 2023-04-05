float rot = 0;

void setup()
{
    size(1280, 800, P2D);
}

void draw()
{
    background(100);

    pushMatrix();
        translate(width/2, height/2);

        ///////////////////////////////
        translate(100, 100);
        scale(3);
        rotate(rot);

        fill(200);
        rect(0, 0, 100, 200);

    popMatrix();
    rot += PI*0.01;
}